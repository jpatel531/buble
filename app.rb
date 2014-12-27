require_relative 'bublé'

get '/' do
	html :index
end

post '/test' do
	params = JSON.parse(body)
	"You sent me #{params.keys}, with the values #{params.values}"
end

run_application