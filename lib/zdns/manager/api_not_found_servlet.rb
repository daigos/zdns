require 'webrick'
require 'webrick/route_servlet'

module ZDNS
  module Manager
    class ApiNotFoundServlet < AbstractApiServlet
      def service(req, res)
        res.status = 404
        _output req, res, {}
      end
    end
  end
end
