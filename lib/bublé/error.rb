module Bublé

	class Error

		@@errors = [
			{
				code: 404,
				headline: "404 Not Found",
				message: "File not found\n"
			},
			{
				code: 500,
				headline: "500 Internal Server Error",
				message: "Internal Server Error\n"
			}
		]

		def self.code(number)
			
			error = @@errors.find {|error| error[:code] == number}
			headline, message = error[:headline], error[:message]

			return "HTTP/1.1 #{headline}\r\n" +
				"Content-Type text/plain\r\n" +
				"Content-Length: #{message.size}\r\n" +
				"Connection: close\r\n" +
				"\r\n" +
				message
		end

	end

end