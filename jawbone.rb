require 'rest-client'
require 'sinatra/base'

class MyApp < Sinatra::Base
  set :server, :thin

  CONFIG = YAML.load_file('.config')
  CLIENT_ID = CONFIG[:client_id]

  get '/' do
    markdown :index
  end

  get '/oauthredirect' do
    CONFIG['new_value'] = 'new'
    CONFIG['code'] = params[:code]
    request_access_token
    File.open('.config', 'w+') {|f| f.write CONFIG.to_yaml }
    "Made it back here - code: #{params[:code]}"
  end

  get '/authorization' do
    "Authorization page"
  end

  get '/about' do
    "About this app!"
  end

  get '/me' do
    user_data = get_user_info["data"]
    erb :me, :locals => { :user_data => user_data }
  end

  def request_access_token
    token_url = "https://jawbone.com/auth/oauth2/token?client_id=#{CONFIG['client_id']}&client_secret=#{CONFIG['app_secret']}&grant_type=authorization_code&code=#{CONFIG['code']}"
    response = JSON.parse(RestClient.get(token_url))
    CONFIG['access_token'] = response["access_token"]
  end

  def get_user_info
    request_url = "https://jawbone.com/nudge/api/v.1.1/users/@me"
    request_headers = {:Authorization => "Bearer #{CONFIG['access_token']}" }
    response = RestClient.get(request_url, request_headers)
    response = JSON.parse(response)
  end

  run! if app_file == $0
end

