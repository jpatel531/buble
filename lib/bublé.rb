require 'socket'
require 'uri'
require 'cgi'
require 'json'
require_relative 'route_register'
require_relative 'response'
require_relative 'error_handler'
require_relative 'request'

module Bublé

	include Bublé::RouteRegister
	include Bublé::Response
	include Bublé::ErrorHandler
	include Bublé::Request

	def run_application
		server = TCPServer.new 'localhost', 5678
		puts "Michael Bublé is recording another Christmas album on port 5678..."

		loop do
			socket = server.accept

			request_line = socket.gets

			next if !request_line

			request = socket.readpartial(1024).split("\r\n\r\n")

			parse(request, request_line)

			STDERR.puts request_line

			parse_route_params

			route_handler ? socket.print(route_handler[:action].call) : socket.print(four_oh_four)

			socket.close

			@route_handler = nil

		end		
	end
end

include Bublé