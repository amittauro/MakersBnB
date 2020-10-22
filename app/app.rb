require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/user'
require_relative 'models/space'
require_relative 'models/reservation'
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
      Reservation.create(date: date, booked: false, space_id: space.id, request: false)
    end

    redirect '/spaces'
  end

  get '/spaces/:id' do
    @space = Space.find_by(id: params[:id])
    @reservations = Reservation.where(space_id: params[:id], booked: false)
    session[:space_id] = params[:id]
    erb :dates
  end

  post '/reservations/:id' do
    reservation = Reservation.find_by(id: params[:id])
    reservation.update(request: true, user_id: session[:user].id)

    redirect '/requests'
  end

  # post '/requests' do
  #   Request.create(user_id: session[:user_id], space_id: session[:space_id], date: Date.parse(params[:date]))
  #   session.delete([:space])
  #
  #   redirect '/requests'
  # end

  get '/requests' do
    @reservations_made = Reservation.where(user_id: session[:user].id, request: true)
    @reservations_received = Reservation.where(request: true).select do |reservation|
      reservation.space.user.id == session[:user].id
    end

    erb :requests
  end

  post '/requests/:id' do
    reservation = Reservation.find_by(id: params[:id])
    reservation.update(booked: true)

    redirect '/requests'
  end

  post '/deny_requests/:id' do
    reservation = Reservation.find_by(id: params[:id])
    reservation.update(booked: false, request: false)

    redirect '/requests'
  end

end
