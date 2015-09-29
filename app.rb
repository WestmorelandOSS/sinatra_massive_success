require 'sinatra'
require 'data_mapper'
require 'dm-migrations'

configure do
  set :datastore, DataMapper.setup(:default, 'sqlite::memory:')
end

class Event
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :start,      DateTime  # A varchar type string, for short strings
  property :duration,   Integer   # Minutes for the event
  property :body,       Text      # A text block, for longer string data.
  property :created_at, DateTime  # A DateTime, for any date you might like.
end

DataMapper.finalize
DataMapper.auto_upgrade!

Event.create({start: Time.now, duration: 10, body: "HEY"})

get '/date' do
  Time.now.to_s
end

get '/' do
  haml :index
end

get '/events' do
  @events = Event.all
  haml :index
end

get '/event/new' do
  haml :new
end

get '/event/edit/:id' do
  @event = Event.get(params[:id])
  haml :edit
end

post '/event/update' do
  start = params[:start]
  duration = params[:duration]
  body = params[:body]
  puts params.inspect
  event = Event.get(params[:id])
  event.update({start: start, duration: duration.to_i, body: body})
  redirect to("/event/#{event.id}")
end

get '/event/:id' do
  @event = Event.get(params[:id])
  haml :show
end


post '/event/create' do
  start = params[:start]
  duration = params[:duration]
  body = params[:body]
  event = Event.create({start: start, duration: duration.to_i, body: body})
  redirect to("/event/#{event.id}")
end
