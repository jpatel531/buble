require 'socket'
require 'uri'
require 'cgi'
require 'json'
require_relative 'bublé/route_registry'
require_relative 'bublé/templates'
require_relative 'bublé/error'
require_relative 'bublé/request'
require_relative 'bublé/route'
require_relative 'bublé/application'
require_relative 'bublé/template'

module Bublé

	include Bublé::RouteRegistry
	include Bublé::Templates

	def run application
		application.new.serve
	end
	
end

include Bublé