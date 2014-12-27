require './lib/bublé'

get '/' do
	html :index
end

get '/query_test' do 
	params.inspect
end

post '/test' do
	params = JSON.parse(body)
	"You sent me #{params.keys}, with the values #{params.values}"
end

run_application