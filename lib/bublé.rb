require 'socket'
require 'uri'
require 'cgi'
require 'json'
require_relative 'route_registry'
require_relative 'fs'
require_relative 'error_handler'
require_relative 'request'
require_relative 'route'

module Bublé

	include Bublé::RouteRegistry
	include Bublé::FS
	include Bublé::ErrorHandler

	attr_reader :params

	def run_application
		server = TCPServer.new 'localhost', 5678
		puts "Michael Bublé is recording another Christmas album on port 5678..."

		loop do
			begin
				socket = server.accept

				request_line = socket.gets

				next if !request_line
				
				STDERR.puts request_line

				socket_data = socket.readpartial(1024).split("\r\n\r\n")

				request = ::Request.parse(socket_data, request_line)

				route_handler = ::Route.handler(request)

				if route_handler
					@params = request.params(route_handler)
					socket.print(route_handler.action.call)
				else
					socket.print(error(404))
				end

				socket.close

			rescue Exception => e
				puts e
				socket.print(error(500))
				socket.close
			end

		end
	end
end

include Bublé