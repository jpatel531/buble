require 'erb'
require 'haml'

module Bublé
	module Templates

		def erb(path) 
			::Template.render(:erb, path)
		end

		def html(path)
			::Template.render(:html, path)
		end

		def haml(path)
			::Template.render(:haml, path)
		end

	end
end