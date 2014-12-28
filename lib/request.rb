module Bublé

	module Request

		attr_accessor :header, :request_line, :request_method, :request_path, :query_params

		def parse(request, request_line)

			raw_header, raw_body = request

			get_request_method(request_line)
			parse_uri(request_line)
			parse_header(raw_header)
			parse_body(raw_body)
		end

		def get_request_method(request_line)
			@request_method = request_line.scan(/\w+/).first
		end

		def parse_uri(request_line)
			raw_uri = request_line.split(" ")[1]
			parsed_uri = URI.parse(raw_uri)
			@request_path = parsed_uri.path
			@query_params = (parsed_uri.query) ? CGI.parse(parsed_uri.query) : {}
		end

		def parse_header(string)
			@header = string.split("\r\n").map do |pair|
				key, value = pair.split(": ")
				{key.to_sym => value}
			end.inject({}, :merge)
		end

		def parse_body(string)
			return @body_params = {} if !string
			@body_params = JSON.parse(string)
			rescue 
				@body_params = CGI.parse(string)
		end

		def parse_route_params

			@route_params = {}

			if @handler[:route_params_regex]
				param_matches = request_path.scan(@handler[:route_params_regex]).flatten
				
				@handler[:route_params_names].each_with_index do |name, index|
					@route_params[name.to_sym] = param_matches[index]
				end
			end
		end

		def params
			@params = @body_params.merge(@query_params).merge(@route_params)
		end

	end

end