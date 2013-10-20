require 'sinatra'
require 'sinatra/base'
require 'sinatra/content_for'
require 'omniauth'
require 'omniauth-github'

require './GitHubApiWrapper.rb'

class WebController < Sinatra::Base

  helpers Sinatra::ContentFor

  configure do
    set :threaded, false
    set :public_folder, 'public'

    scopeAll = 'user,public_repo,repo,gist'
    if (ENV['RACK_ENV'] == 'production')
      use Rack::Session::Cookie, :key => 'rack.session',
      :domain => 'octoscrum.r13.railsrumble.com',
      :path => '/',
      :expire_after => 2592000, # In seconds
      :secret => 'qwerty'

      use OmniAuth::Builder do
        provider :github, '834f0982eebc5b9044a7', '19c3325963b8b3fff96f2df24f0070aed0b0540e', scope: scopeAll
      end

    end

    if (ENV['RACK_ENV'] == 'development')
      use Rack::Session::Cookie, :key => 'rack.session',
        :domain => 'localhost',
        :path => '/',
        :expire_after => 2592000, # In seconds
        :secret => 'qwerty'
        enable :logging

      use OmniAuth::Builder do
        provider :github, '6766f10878e0bb685723', '12f1f586e119c7ca275654300674f73d599cc6ed', scope: scopeAll
      end
    end
  end

  def authenticated?
      session[:authenticated]
  end

  def authorize!
    redirect '/' unless authenticated?
  end

  def logout!
    #session[:authenticated] = false
    session.clear
  end

  #/projects/{projectid}/{iterationid}

  get '/' do
    if authenticated?
      erb :projects
    else
      erb :index
    end
  end

  get '/auth/github/callback' do
    session[:uid] = env['omniauth.auth']['uid']
    token = env['omniauth.auth']['credentials']['token']
    session[:username] = env['omniauth.auth']['info']['name']
    login = env['omniauth.auth']['info']['nickname']
    session[:authenticated] = true

    session[:login] = login
    session[:token] = token

    user = GitHubApiWrapper::User.new(login, token)
    session[:avatarUrl] = 'http://www.gravatar.com/avatar/' + user.getGravatarId()

    redirect to('/projects')
  end

  get '/auth/failure' do
    params[:message]
    'Something went wrong. Fuck.'
  end

  get '/auth/signout' do
    logout!
    redirect to('/')
  end

  get '/projects' do
    authorize!
    erb :projects
  end

  get '/planning' do
    erb :project
  end

  get '/projects/:projectid' do |projectid|
    authorize!
    erb :project
  end

  get '/projects/:projectid/:iterationid' do |projectid, iterationid|
    authorize!
    erb :project
    #erb :iteration
  end

  get '/planning' do
    authorize!
    erb :planning
  end

  get '/token' do
    erb :main
  end
end
