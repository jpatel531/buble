module Bublé

	module ErrorHandler

		def error code
			case code
			when 404
				headline = "404 Not Found"
				message = "File not found\n"
			when 500
				headline = "500 Internal Server Error"
				message = "Internal Server Error\n"
			end

			return "HTTP/1.1 #{headline}\r\n" +
				"Content-Type text/plain\r\n" +
				"Content-Length: #{message.size}\r\n" +
				"Connection: close\r\n" +
				"\r\n" +
				message
		end

	end

end