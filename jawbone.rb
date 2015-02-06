require 'sinatra'

set :server, :thin

CLIENT_ID = "rgJ_zKbU5Zk"


get '/' do
  markdown :index
end

get '/oauthredirect' do
  "Made it back here"
end

get '/authorization' do
  "Authorization page"
end

get '/about' do
  "About this app!"
end
