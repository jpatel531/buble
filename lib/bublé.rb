require 'socket'
require 'uri'
require 'cgi'
require 'json'
require_relative 'route_registry'
require_relative 'fs'
require_relative 'error'
require_relative 'request'
require_relative 'route'

module Bublé

	include Bublé::RouteRegistry
	include Bublé::FS

	class Application

		attr_reader :server, :params

		def initialize host='localhost', port=5678
			@server = TCPServer.new host, port
		end

		def serve
			STDOUT.puts "Michael Bublé is recording another Christmas album on port 5678..."
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
						socket.print instance_eval(&route_handler.action)
					else
						socket.print ::Error.code(404)
					end

					socket.close

				rescue Exception => e
					puts e
					socket.print ::Error.code(500)
					socket.close
				end
			end
		end
	end
	
end

include Bublé