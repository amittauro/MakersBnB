require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/user'
require_relative 'models/space'
require_relative 'models/reservation'
require_relative 'models/request'
require 'pry'
require 'sinatra/flash'
require 'date'

class MakersAirBnB < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register Sinatra::Flash

  enable :sessions
  enable :method_override

  get '/' do
    flash[:passwords_not_matching]
    erb :registration
  end

  post '/registration' do
    if params[:password] == params[:password_confirmation]
      User.create(email: params[:email], password: params[:password],
        password_confirmation: params[:password_confirmation])
    else
      flash[:passwords_not_matching] = "password and password_confirmation don't match"
    end
    redirect '/'
  end

  get '/sessions/new' do
    erb :new_session
  end

  post '/sessions/new' do
    if User.login(email: params[:email], password: params[:password])
      session[:user] = User.find_by(email: params[:email])
      redirect '/spaces'
    end

    redirect '/sessions/new'
  end

  get '/spaces' do
    @user = User.find_by(id: session[:user].id)
    @spaces = Space.all
    erb :spaces
  end

  delete '/sessions' do
    session.delete([:user_id])
    redirect '/'
  end

  get '/spaces/new' do
    erb :new_space
  end

  post '/spaces/new' do
    space = Space.create(user_id: session[:user].id, name: params[:name], description: params[:description],
      price: params[:price], from: Date.parse(params[:from]), to: Date.parse(params[:to]))
    Date.parse(params[:from]).step(Date.parse(params[:to])).each do |date|
      Reservation.create(date: date, booked: false, space_id: space.id)
    end

    redirect '/spaces'
  end

  post '/spaces/:id' do
    session[:space_id] = params[:id]
    redirect "/dates"
  end

  get "/dates" do
    @reservations = Reservation.where(space_id: session[:space_id], booked: false)

    erb :dates
  end

  post '/requests/:id' do
    Request.create(reservation_id: params[:id], space_id: session[:space_id], user_id: session[:user].id)

    redirect '/requests'
  end

  get '/requests' do
    @requests_made = Request.where(user_id: session[:user].id)
    @requests_received = Request.all.select do |request|
      request.space.user.id == session[:user].id
    end

    erb :requests
  end

  post '/approve/:id' do
    request = Request.find_by(id: params[:id])
    request.reservation.update(booked: true)
    request.destroy
    redirect '/requests'
  end

  post '/deny/:id' do
    request = Request.find_by(id: params[:id])
    request.destroy
    redirect '/requests'
  end

end
