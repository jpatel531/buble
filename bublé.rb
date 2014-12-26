require 'socket'
require 'uri'
require 'json'

WEB_ROOT = './public'

CONTENT_TYPE_MAPPING = {
	html: 'text/html',
	txt: 'text/plain',
	png: 'image/png',
	jpg: 'image/jpeg'
}

DEFAULT_CONTENT_TYPE = 'application/octet-stream'

@routes ||= []

def get(path, &block) 
	http_method('GET', path, &block)
end

def post(path, &block)
	http_method('POST', path, &block) 
end

def http_method(method, path, &block)
	@routes << {method: method, path: path, action: block}
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

def four_oh_four
	message = "File not found\n"

	return "HTTP/1.1 404 Not Found\r\n" +
		"Content-Type text/plain\r\n" +
		"Content-Length: #{message.size}\r\n" +
		"Connection: close\r\n" +
		"\r\n" +
		message
end

def content_type(path)
	ext = File.extname(path).split(".").last
	CONTENT_TYPE_MAPPING.fetch(ext.to_sym, DEFAULT_CONTENT_TYPE)
end

def requested_file(request_path)
	path 					= URI.unescape(URI(request_path).path)

	clean = []
	parts = path.split("/")

	parts.each do |part|
		next if part.empty? || part == "."
		part == ".." ? clean.pop : clean << part
	end

	File.join(WEB_ROOT, *clean)

end

def run_application
	server = TCPServer.new 'localhost', 5678
	puts "Michael Bublé is recording another Christmas album on port 5678..."

	loop do
		socket 				= server.accept
		request_line 	= socket.gets

		STDERR.puts request_line

		request_method = request_line.scan(/\w+/).first

		data = socket.readpartial(1024).split("\r\n\r\n")

		header 	= data.first
		body 	= data.last

		request_path		= request_line.split(" ")[1]

		handler = @routes.find {|route| (route[:method] == request_method) && (route[:path] == request_path)  }

		handler ? socket.print(handler[:action].call) : socket.print(four_oh_four)

		socket.close
	end
end