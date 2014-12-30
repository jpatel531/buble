module Bublé
	class Request

		class << self

			def parse(request, request_line)
				raw_header, raw_body = request

				request_method = get_request_method(request_line)
				request_path, query_params = parse_uri(request_line)
				header = parse_header(raw_header)
				body_params = parse_body(raw_body)

				new(request_method, request_path, query_params, header, body_params)
			end

			def get_request_method(request_line)
				request_line.scan(/\w+/).first
			end

			def parse_uri(request_line)
				raw_uri = request_line.split(" ")[1]
				parsed_uri = URI.parse(raw_uri)
				request_path = parsed_uri.path
				query_params = (parsed_uri.query) ? CGI.parse(parsed_uri.query) : {}

				[request_path, query_params]
			end

			def parse_header(string)
				string.split("\r\n").map do |pair|
					key, value = pair.split(": ")
					{key.to_sym => value}
				end.inject({}, :merge)
			end

			def parse_body(string)
				return {} if !string
				JSON.parse(string)
				rescue 
					CGI.parse(string)
			end

		end

		attr_accessor :http_method, :path, :query_params, :header, :body_params, :route_params, :params

		def initialize http_method, path, query_params, header, body_params
			@http_method, @path, @query_params, @header, @body_params = http_method, path, query_params, header, body_params 
		end

		def params(route_handler)
			parse_route_params(route_handler)
			@params = body_params.merge(query_params).merge(route_params)
		end

		def parse_route_params(route_handler)
			@route_params = {}

			if route_handler.route_params_regex
				param_matches = path.scan(route_handler.route_params_regex).flatten

				route_handler.route_params_names.each_with_index do |name, index|
					@route_params[name.to_sym] = param_matches[index]
				end
			end
			@route_params
		end

	end

end