## Getting Started with the Jawbone API

Authenticating with a new API can be tricky. This guide will help you get started with the Jawbone API by going from zero to authenticated.

Tools used in this example:

- [Jawbone API Documentation](https://jawbone.com/up/developer/)
- [The Ruby Programming Language](https://www.ruby-lang.org/en/)
- [Sinatra Web Framework](http://www.sinatrarb.com)
- [Thin Web Server](http://code.macournoyer.com/thin/)
- OpenSSL for certificate generation (HTTPS)

### Register Your Application with Jawbone

1. To make use of the Jawbone API, you'll first need to [register for a Jawbone Account](https://jawbone.com/start/signup).
2. Once you have an account and are signed in you'll need to [register a new application on the Jawbone Developer Portal](https://jawbone.com/up/developer/apps/create).
3. You can also [view the existing organizations applications you have registered with Jawbone](https://jawbone.com/up/developer/account).

### Set up your basic Sinatra App

1. Create a directory on your machine to hold all the files for your app
2. Install sinatra if you need to by running either

```bash
> gem install sinatra
```

or by adding

```ruby
  gem 'sinatra'
```

to your Gemfile and then run `bundle install`. If you're not yet familiar with bundler you can [read more about about ruby dependency management on the Bundler website](http://bundler.io).

You can then create a ruby file file to hold the contents of your application. We'll call that file jawbone.rb:

```ruby
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


```



### Create Certificates and Prepare for local HTTPS

When an application authenticates with Jawbone via oauth, Jawbone will redirect the user to your application. Jawbone will only redirect to a page in your application in a secure manner (via HTTPS). This may add some complexity to developing your application but is necessary to provide the appropriate level of privacy and security in the best interest of Jawbone users.

To run your your app with HTTPS on your local development machine, you'll first need to generate SSL certificates.

Please follow this [Heroku SSL guide](https://devcenter.heroku.com/articles/ssl-certificate-self) create this certificates for use with your application.

### Serve your web App

You'll first need to create a `config.ru` file. This will allow you start the web server via rack.

Create a file named `config.ru` in the directory for your application and give it the following contents:

```ruby
# This file allows the app to be run via Rack
# config.ru (run with rackup)
require './jawbone'
run MyApp
```

Sinatra typically uses a web server called WebBrick. Unfortunately WebBrick does not support using HTTPS, so we'll use [a web server that supports HTTPS called Thin](http://code.macournoyer.com/thin/).

```bash
> thin --rackup config.ru --ssl --ssl-key-file server.key --ssl-cert-file server.crt -p 4567 start
```

### Get your Authentication Redirect Working


### Get An Access Token for your User

Once the user has approved your app and been redirected back to your app, you'll then need to make a final request to a Jawbone server to get an access token. This will allow you to make calls for the user's information to use within your app.

For this we'll use the ruby gem `rest-client`. Install it at the command line:

```bash
> gem install rest-client
```

or add it to your Gemfile

```ruby
  gem 'rest-client'
```

and run `> bundle install`. Include `rest-client` at the top of your `jawbone.rb` file.

```ruby
require 'rest-client'
```

You can then define a helper method in your `jawbone.rb` file to request the access token for you:

```ruby
  # A helper method to make the server to server call
  # to get an access_token
  def request_access_token
    token_url = "https://jawbone.com/auth/oauth2/token?client_id=#{CONFIG['client_id']}&client_secret=#{CONFIG['app_secret']}&grant_type=authorization_code&code=#{CONFIG['code']}"
    response = JSON.parse(RestClient.get(token_url))
    CONFIG['access_token'] = response["access_token"]
  end
```
Store this in with your user record in your database and you should be good to go!

### Create your app!

Now that we've got you authenticated, you should be ready and raring to do what is important to you, developing your app and creating a great experience for your users! Get after it, and join us in advancing the state of wellness in the world through technology. Don't forget you can always contact us at developersupportemail@jawbone.com with if you run into any issues or have any questions or suggestions.


