module Bublé
	class Route

		@@routes ||= []

		def self.all
			@@routes
		end

		def self.handler(request)
			all.find do |route| 
				route.method == request.http_method && (route.path == request.path ||
					route.route_params_regex &&
					route.path.split("/").length == request.path.split("/").length &&
					route.route_params_regex =~ request.path)
			end
		end

		attr_accessor :method, :path, :action, :route_params_regex, :route_params_names

		def initialize(method, path, &block)
			@method, @path, @action = method, path, block
			set_route_params
			@@routes << self
		end

		def set_route_params
			if path =~ /:\w+/
				route_params = path.scan(/:\w+/)

				positions = route_params.map {|param| path.split("/").index(param)}

				regex_string = path

				route_params.each { |param| regex_string.gsub!(param, '(\w+)') }

				@route_params_regex = Regexp.new(regex_string)
				@route_params_names = route_params.map {|param| param.delete(":")}

			end
		end

	end
end