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

				route_params = path.scan(/:\w+/)

				positions = route_params.map {|param| path.split("/").index(param)}

				regex_string = path

				route_params.each { |param| regex_string.gsub!(param, '(\w+)') }

				route[:route_params_regex] = Regexp.new(regex_string)
				route[:route_params_names] = route_params.map {|param| param.delete(":")}

			end

			routes << route
		end

		def route_handler
			@route_handler ||= routes.find do |route| 
				route[:method] == request_method && (route[:path] == request_path ||
					route[:route_params_regex] &&
					route[:path].split("/").length == request_path.split("/").length &&
					(route[:route_params_regex] =~ request_path))
			end
		end

	end
end