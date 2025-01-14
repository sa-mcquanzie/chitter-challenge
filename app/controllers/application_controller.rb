require 'dotenv/load'
require 'active_record'
require 'sinatra'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base
  configure do
    enable :sessions

    set :method_override, true
    set :public_folder, 'public'
    set :views, 'app/views'
    
    config = YAML::safe_load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(config['test'])
  end

  before do
    @current_user = session[:current_user]
    @users = User.all
    @peeps = Peep.all
  end

  get '/' do
    erb :index
  end

  get '/signinorup' do
    erb :signinorup
  end

  get '/failure' do
    erb :failure
  end

  post '/add-user' do
    user = User.new
    user.name = params[:name]
    user.username = params[:username]
    user.email = params[:email]
    user.password = params[:password]

    if user.save
      session[:current_user] = User.find_by(username: params[:username])
      redirect '/'
    else
      redirect '/failure'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      session[:current_user] = User.find_by(username: params[:username])
      redirect '/'
    else
      redirect '/failure'
    end

  end

  get '/logout' do
    session[:current_user] = nil

    redirect '/'
  end

  post '/create-peep' do
    peep = Peep.new
    peep.body = params[:'peep-body']
    peep.user_id = params[:'user-id']

    if peep.save
      redirect '/'
    else
      redirect '/failure'
    end
  end

  run! if app_file == $0
end
