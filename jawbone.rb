require 'sinatra/base'

class MyApp < Sinatra::Base
  set :server, :thin

  CLIENT_ID = "rgJ_zKbU5Zk"


  get '/' do
    markdown :index
  end

  get '/oauthredirect' do
    "Made it back here - code: #{params[:code]}"
  end

  get '/authorization' do
    "Authorization page"
  end

  get '/about' do
    "About this app!"
  end

  run! if app_file == $0
end

