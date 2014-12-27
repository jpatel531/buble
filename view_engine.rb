module Bublé
	module ViewEngine

		def html(path)
			path = requested_file(path.to_s + ".html")

			if File.exist?(path) && !File.directory?(path)
				File.open(path, "rb") do |file|
					return  "HTTP/1.1 200 OK\r\n" +
					"Content-Type: #{content_type(file)}\r\n" +
					"Content-Length: #{file.size}\r\n" +
					"Connection: close\r\n" + 
					"\r\n" +
					IO.read(file)
				end
			else
				return four_oh_four
			end
		end

	end
end