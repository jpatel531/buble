module Bublé

	module Request

		attr_accessor :header, :request_line, :request_method, :request_path, :query_params

		def parse(request, request_line)

			raw_header, raw_body = request

			get_request_method(request_line)
			parse_uri(request_line)
			parse_header(raw_header)
			parse_body(raw_body) if raw_body
		end

		def get_request_method(request_line)
			@request_method = request_line.scan(/\w+/).first
		end

		def parse_uri(request_line)
			raw_uri = request_line.split(" ")[1]
			parsed_uri = URI.parse(raw_uri)
			@request_path = parsed_uri.path
			@query_params = CGI.parse parsed_uri.query if parsed_uri.query
		end

		def parse_header(string)
			@header = string.split("\r\n").map do |pair|
				key, value = pair.split(": ")
				{key.to_sym => value}
			end.inject({}, :merge)
		end

		def parse_body(string)
			@params = JSON.parse(string)
			rescue 
				@params = CGI.parse(string)
		end

		def params
			query_params ? @params.merge(query_params) : @params
		end

	end

end