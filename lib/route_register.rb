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

		# class << self

			def route_handler(request)

				@route_handler ||= routes.find do |route| 
					route[:method] == request.http_method && (route[:path] == request.path ||
						route[:route_params_regex] &&
						route[:path].split("/").length == request.path.split("/").length &&
						(route[:route_params_regex] =~ request.path))
				end

				puts @route_handler.inspect

				request.parse_route_params(@route_handler) unless request.route_params

			end

		# end

	end
end