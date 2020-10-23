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
    user = User.login(email: params[:email], password: params[:password])
        # if User.login(email: params[:email], password: params[:password])
        # User.find_by(email: params[:email])
    if user
      session[:user_id] = user.id
      #seesion[:user_id] = user.id
      redirect '/spaces'
    else
      redirect '/sessions/new'
    end
  end

  # SESSION TO STORE SOMETHING SIMPLE
  # method for current user
  # session[:user_id] = User.find_by(email: params[:email]).id

  get '/spaces' do
    @user = User.find_by(id: session[:user_id])
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

  #POST '/SPACES'

  post '/spaces/new' do
    space = Space.create(
      user_id: session[:user_id],
      name: params[:name],
      description: params[:description],
      price: params[:price],
      )

      #instance method on a space (FIND ITS RESERVATIONS)

    Reservation.create_range(from: params[:from], to: params[:to], space_id: space.id)

    redirect '/spaces'
  end

  # post '/spaces/:id' do
  #   session[:space_id] = params[:id]
  #   redirect "/dates"
  # end

  # get spaces/:id of space / dates

  get "/dates" do
    @reservations = Reservation.where(space_id: params[:space_id], booked: false)

    erb :dates
  end

  #input type hidden value = space.id
  # posting handing info over to the server that it doesnt have

  # below it implies that you're doing something to a certain request which you're not
  # do hidden id

  post '/requests/:id' do
    reservation = Reservation.find_by(id: params[:id])
    Request.create(reservation_id: params[:id], space_id: reservation.space.id, user_id: session[:user_id])

    redirect '/requests'
  end

  get '/requests' do
    @requests_made = Request.where(user_id: session[:user_id])
    @requests_received = Request.where(confirmed: nil).select do |request|
      request.space.user.id == session[:user_id]
    end

    # Self.all within the method.
    # request approved or denied?
    # user.spaces.requests
    # pushed for time whats necessary?

    erb :requests
  end

  # user.spaces => spaces of the current user => each space.requests

  # user.spaces.each in view file


  patch '/requests/:id' do
    request = Request.find_by(id: params[:id])
    request.update(confirmed: true)
    if params['status'] == 'approve'
      request.reservation.update(booked: true)
    end

    redirect '/requests'
  end

end
