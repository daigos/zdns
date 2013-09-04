require 'webrick'
require 'webrick/route_servlet'
require 'json'

module ZDNS
  module Manager
    class AbstractApiServlet < WEBrick::RouteServlet::ActionServlet
      def service(req, res)
        begin
          super
        ensure
          ActiveRecord::Base.connection.close
        end
      end

      def _permit_query(req, *keys)
        params = JSON.parse(req.body) rescue {}
        keys = keys.flatten
        params.select{|k,v| keys.include?(k.to_sym)}
      end

      def _output(req, res, obj)
        res.content_type = "application/json"
        if Exception===obj
          obj = {:message => obj.message}
        end
        #ActiveRecord::Base.connection_pool.with_connection do
          res.body = obj.to_json
        #end
      end
    end
  end
end
