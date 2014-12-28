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
			request = socket.readpartial(1024).split("\r\n\r\n")

			next if !request_line

			parse(request, request_line)

			STDERR.puts request_line

			handler = @handler = @routes.find do |route| 

				route[:method] == request_method && 
				(route[:path] == request_path ||

					route[:route_params_regex] &&
					route[:path].split("/").length == request_path.split("/").length &&
					(route[:route_params_regex] =~ request_path)

				)
			end

			parse_route_params

			handler ? socket.print(handler[:action].call) : socket.print(four_oh_four)

			socket.close
		end		
	end
end

include Bublé