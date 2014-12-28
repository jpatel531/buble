require 'socket'
require 'uri'
require 'cgi'
require 'json'
require_relative 'route_register'
require_relative 'view_engine'
require_relative 'error_handler'
require_relative 'request'

module Bublé

	include Bublé::RouteRegister
	include Bublé::ViewEngine
	include Bublé::ErrorHandler
	include Bublé::Request

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

	def run_application
		server = TCPServer.new 'localhost', 5678
		puts "Michael Bublé is recording another Christmas album on port 5678..."

		loop do
			socket = server.accept

			request_line = socket.gets
			request = socket.readpartial(1024).split("\r\n\r\n")

			next if !request_line

			parse(request, request_line)

			STDERR.puts request_line

			handler = @routes.find {|route| (route[:method] == request_method) && (route[:path] == request_path)  }

			handler ? socket.print(handler[:action].call) : socket.print(four_oh_four)

			socket.close
		end		
	end
end

include Bublé