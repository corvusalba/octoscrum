require 'sinatra'
require 'sinatra/base'
require 'omniauth'
require 'omniauth-github'

class WebController < Sinatra::Base

  configure do
    set :threaded, false
    set :public_folder, 'public'
    #enable :sessions
    use Rack::Session::Cookie, :key => 'rack.session',
                           :domain => 'localhost',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'qwerty'

    #use Rack::Session::Cookie
    use OmniAuth::Builder do
      provider :github, '6766f10878e0bb685723', '12f1f586e119c7ca275654300674f73d599cc6ed'
    end
  end

  def authenticated?
      session[:authenticated]
  end

  def authorize!
    redirect '/' unless authenticated?
  end

  def logout!
    session[:authenticated] = false
  end

  get '/' do
    if authenticated?
      erb :main
    else
      erb :index
    end
  end

  get '/auth/github/callback' do
    session[:uid] = env['omniauth.auth']['uid']
    session[:token] = env['omniauth.auth']['token']
    session[:username] = env['omniauth.auth']['info']['name']
    session[:nickname] = env['omniauth.auth']['info']['nickname']
    session[:authenticated] = true
    token = env['omniauth.auth']['credentials']['token']

    redirect to('/')
  end

  get '/auth/failure' do
    params[:message]
    'Something went wrong. Fuck.'
  end

  get '/auth/signout' do
    logout!
    redirect to('/')
  end
end
