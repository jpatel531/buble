require 'socket'
require 'uri'
require 'cgi'
require 'json'
require_relative 'route_registry'
require_relative 'fs'
require_relative 'error'
require_relative 'request'
require_relative 'route'
require_relative 'application'
require_relative 'template'

module Bublé

	include Bublé::RouteRegistry
	include Bublé::FS

	def run application
		application.new.serve
	end
	
end

include Bublé