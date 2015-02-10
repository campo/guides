require 'rest-client'
require 'sinatra/base'

class MyApp < Sinatra::Base
  # We use thin as the web server for our
  # Sinatra app because it allows us to
  # serve HTTPS locally
  set :server, :thin

  # Loading our config file. This is currently
  # acting as a database for our sample app.
  # You would want to use a real database for
  # your app.
  CONFIG = YAML.load_file('.config')
  CLIENT_ID = CONFIG[:client_id]

  # The web app's main page
  get '/' do
    erb :index
  end

  # The page to handle the return redirect
  # when the user give's you permissions to their
  # Jawbone account.
  get '/oauthredirect' do
    CONFIG['new_value'] = 'new'
    CONFIG['code'] = params[:code]
    request_access_token
    File.open('.config', 'w+') {|f| f.write CONFIG.to_yaml }
    "Made it back here - code: #{params[:code]}"
  end

  # The page in on your site the user visits to
  # authorize
  get '/authorization' do
    "Authorization page"
  end

  # Your site's about page
  get '/about' do
    "This is a sample app using the Jawbone API!"
  end

  # A page to display the current user's
  # information.
  get '/me' do
    user_data = get_user_info["data"]
    erb :me, :locals => { :user_data => user_data }
  end

  # A helper method to make the server to server call
  # to get an access_token
  def request_access_token
    token_url = "https://jawbone.com/auth/oauth2/token?client_id=#{CONFIG['client_id']}&client_secret=#{CONFIG['app_secret']}&grant_type=authorization_code&code=#{CONFIG['code']}"
    response = JSON.parse(RestClient.get(token_url))
    CONFIG['access_token'] = response["access_token"]
  end

  # A helper method that makes an API call and returns
  # the Jawbone user's information
  def get_user_info
    request_url = "https://jawbone.com/nudge/api/v.1.1/users/@me"
    request_headers = { :Authorization => "Bearer #{CONFIG['access_token']}" }
    response = RestClient.get(request_url, request_headers)
    response = JSON.parse(response)
  end

  run! if app_file == $0
end

