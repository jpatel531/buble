require 'socket'
require 'uri'
require 'cgi'
require 'json'
require_relative 'route_register'
require_relative 'response'
require_relative 'error_handler'
require_relative 'request'
require_relative 'route'

module Bublé

	include Bublé::RouteRegister
	include Bublé::Response
	include Bublé::ErrorHandler

	attr_accessor :params

	def run_application
		server = TCPServer.new 'localhost', 5678
		puts "Michael Bublé is recording another Christmas album on port 5678..."

		loop do
			socket = server.accept

			request_line = socket.gets

			next if !request_line

			socket_data = socket.readpartial(1024).split("\r\n\r\n")

			request = ::Request.parse(socket_data, request_line)

			route_handler = ::Route.handler(request)

			STDERR.puts request_line

			@params = request.params(route_handler)

			route_handler ? socket.print(route_handler.action.call) : socket.print(four_oh_four)

			socket.close

		end		
	end
end

include Bublé