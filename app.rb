require './lib/bublé'

get '/' do
	html :index
end

get '/404' do
	html :nonexistent
end

get '/erb' do
	@test = "Instance variable!"
	erb :embedded
end

get '/haml' do
	haml :haml
end

get '/json' do
	{success:200}.to_json
end

get '/query_test' do 
	params.inspect
end

post '/test' do
	"You sent me #{params.keys}, with the values #{params.values}"
end

get '/route/:test' do
	"<h1>Hello #{params[:test]}</h1>"
end

get '/route/:test/bla/:lala' do
	"<h1>Hello there #{params[:test]}, and hello there #{params[:lala]}"
end

run Bublé::Application