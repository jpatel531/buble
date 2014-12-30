module Bublé
	module RouteRegistry

		def get(path, &block) 
			::Route.new('GET', path, &block)
		end

		def post(path, &block)
			::Route.new('POST', path, &block)
		end

	end
end