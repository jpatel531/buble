module Bublé
	module RouteRegister

		attr_accessor :routes

		def routes
			@routes ||= []
		end

		def get(path, &block) 
			register_action('GET', path, &block)
		end

		def post(path, &block)
			register_action('POST', path, &block) 
		end

		def register_action(method, path, &block)

			route = {method: method, path: path, action: block}

			if path =~ /:\w+/
				# /:\w+/.match(path).to_a.each do |match|
				# 	new_path = path.gsub(match, '(\w+)')
				# end

				route_param = /:\w+/.match(path)[0]
				route[:route_params_regex] = Regexp.new(path.gsub(route_param, '(\w+)'))
			end

			routes << route
		end
	end
end