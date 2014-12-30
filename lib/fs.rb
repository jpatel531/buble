require 'erb'

module Bublé
	module FS

		def erb(path) 
			::Template.render(:erb, path)
		end

		def html(path)
			::Template.render(:html, path)
		end

	end
end