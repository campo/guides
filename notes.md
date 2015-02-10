## Getting Started with the Jawbone API

Authenticating with a new API can be tricky. This guide will help you get started with the Jawbone API by going from zero to authenticated.

Tools used in this example:

- [The Ruby Programming Language](https://www.ruby-lang.org/en/)
- [Sinatra Web Framework](http://www.sinatrarb.com)
- [Thin Web Server](http://code.macournoyer.com/thin/)
- OpenSSL for certificate generation (HTTPS)

### Authentication
https://jawbone.com/up/developer/authentication

- Don't link to URLs that can't be read/aren't useful in the browser (https://jawbone.com/auth/oauth2/auth)
- Do link to the developer portal
- include the steps/links to register a new app for API access (start at the absolute beginning)
- Are response_type, client_id, scope, redirect_uri supposed to be URL params? Passed as headers? (The answer turns out to be URL Params)
- should just scroll through to next section, not require you to click the link in the left sidebar (to get to the next thing "Structure")
- Can apps that are in development be allowed to redirect back to a non HTTPS page? This could possibly really lower the barrier to entry for developers.

- [Heroku SSL guide](https://devcenter.heroku.com/articles/ssl-certificate-self)

### Helpful Stack Overflow Links
- [Using HTTPS locally with Sinatra](http://stackoverflow.com/questions/11193465/testing-https-on-sinatra-locally)
- [How to create SSL certificates to test your app with HTTPS locally](https://devcenter.heroku.com/articles/ssl-certificate-self)
- [Using the Thin Web Server with Sinatra for local HTTPS](http://stackoverflow.com/questions/11405161/can-i-enable-ssl-in-sinatra-with-thin)
- http://stackoverflow.com/questions/8340943/deploying-sinatra-app-with-config-ru-on-heroku-cedar-stack
- http://code.macournoyer.com/thin/usage/
- http://stackoverflow.com/questions/14532959/how-do-you-save-values-into-a-yaml-file
- http://nathanhoad.net/how-to-return-json-from-sinatra

### Thin Command for SSL
Now to run your Sinatra app locally, you'll need to start your thin web server with SSL enabled. This will allow your app to authorize and function properly when the Jawbone authenticate redirects back to your app using HTTPS.
```bash
> thin --rackup config.ru --ssl --ssl-key-file server.key --ssl-cert-f
ile server.crt -p 4567 start
```


https://localhost:4567/oauthredirect?code=FmdS-pQcsZ2F-9o0X1HftmGWwCQQ62uWURbKVjDTx2cdv0rNxcBdY90Z0mWVMTbFANA90H2Oo1al19znQ-7Xk8ZEG9MffL2b6ZJxVteWY4OGHTTJRkXyBL4gS7Gx8G1wJfXm-1Nxg7KnFpAnVUcWgrVYlkN3Wd-i_syskO3qbQ6qkAed4qAVZ-TyU0ebYSFdEsxzoBORm0U
