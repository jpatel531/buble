module Bublé

	module RouteRegister

		attr_accessor :routes

		def routes
			@routes ||= []
		end

		def get(path, &block) 
			register_action('GET', path, &block)
		end

		def post(path, &block)
			register_action('POST', path, &block) 
		end

		def register_action(method, path, &block)
			routes << {method: method, path: path, action: block}
		end
	end

end