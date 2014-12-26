require_relative 'bublé'

get '/' do
	html :index
end

post '/test' do
	{success:200}.to_json
end

run_application