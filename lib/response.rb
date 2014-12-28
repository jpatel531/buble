module Bublé
	module Response

		WEB_ROOT = './public'

		CONTENT_TYPE_MAPPING = {
			html: 'text/html',
			txt: 'text/plain',
			png: 'image/png',
			jpg: 'image/jpeg'
		}

		DEFAULT_CONTENT_TYPE = 'application/octet-stream'

		def content_type(path)
			ext = File.extname(path).split(".").last
			CONTENT_TYPE_MAPPING.fetch(ext.to_sym, DEFAULT_CONTENT_TYPE)
		end

		def requested_file(request_path)
			path = URI.unescape(URI(request_path).path)
			
			clean = []
			parts = path.split("/")

			parts.each do |part|
				next if part.empty? || part == "."
				part == ".." ? clean.pop : clean << part
			end

			File.join(WEB_ROOT, *clean)
		end

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