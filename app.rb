require 'sinatra'


get '/' do
  haml :index
end

get '/date' do
  Time.now.to_s
end
