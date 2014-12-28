require './lib/bublé'

get '/' do
	html :index
end

get '/query_test' do 
	params.inspect
end

post '/test' do
	"You sent me #{params.keys}, with the values #{params.values}"
end

get '/route/:test' do
	"<h1>Hello World </h1>"
end

run_application