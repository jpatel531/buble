module Bublé
	class Template

		class << self

			WEB_ROOT = './public'

			CONTENT_TYPE_MAPPING = {
				html: 'text/html',
				txt: 'text/plain',
				png: 'image/png',
				jpg: 'image/jpeg'
			}

			DEFAULT_CONTENT_TYPE = 'application/octet-stream'

			def render(type, path)

				path = requested_file(path.to_s + "." + type.to_s)

				if exists?(path)
					File.open(path, "rb") do |file|
						file = read(file, type)
						return header(path, file) + file
					end
				else
					return ::Error.code(404)
				end
			end

			def exists?(path)
				File.exist?(path) && !File.directory?(path)
			end

			def read(file, type)
				case type
				when :html
					IO.read(file)
				when :erb
					ERB.new(IO.read(file)).result
				end
			end

			def header(path, file)
				"HTTP/1.1 200 OK\r\n" +
				"Content-Type: #{content_type(path)}\r\n" +
				"Content-Length: #{file.size}\r\n" +
				"Connection: close\r\n" + 
				"\r\n"
			end

			def content_type(path)
				ext = File.extname(path).split(".").last
				ext = "html" if ext == "erb"
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
		end
	end
end