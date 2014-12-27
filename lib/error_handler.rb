module Bublé

	module ErrorHandler

		def four_oh_four
			message = "File not found\n"

			return "HTTP/1.1 404 Not Found\r\n" +
				"Content-Type text/plain\r\n" +
				"Content-Length: #{message.size}\r\n" +
				"Connection: close\r\n" +
				"\r\n" +
				message
		end

	end

end