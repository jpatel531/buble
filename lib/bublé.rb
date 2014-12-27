require 'socket'
require 'uri'
require 'cgi'
require 'json'
require_relative 'route_register'
require_relative 'view_engine'
require_relative 'error_handler'

module Bublé

	include Bublé::RouteRegister
	include Bublé::ViewEngine
	include Bublé::ErrorHandler

	WEB_ROOT = './public'

	CONTENT_TYPE_MAPPING = {
		html: 'text/html',
		txt: 'text/plain',
		png: 'image/png',
		jpg: 'image/jpeg'
	}

	DEFAULT_CONTENT_TYPE = 'application/octet-stream'

	attr_accessor :header, :body, :params

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

			STDERR.puts request_line

			break if !request_line

			request_method = request_line.scan(/\w+/).first

			data = socket.readpartial(1024).split("\r\n\r\n")

			@header = data.first
			@body = data.last

			raw_uri = request_line.split(" ")[1]
			parsed_uri = URI.parse(raw_uri)

			request_path = parsed_uri.path
			@params = CGI.parse parsed_uri.query if parsed_uri.query

			handler = @routes.find {|route| (route[:method] == request_method) && (route[:path] == request_path)  }

			handler ? socket.print(handler[:action].call) : socket.print(four_oh_four)

			socket.close
		end		
	end
end

include Bublé