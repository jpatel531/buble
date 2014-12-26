require_relative 'bublé'

get '/' do
	html :index
end

run_application