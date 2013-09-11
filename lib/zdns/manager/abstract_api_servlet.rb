require 'webrick'
require 'webrick/route_servlet'
require 'json'

module ZDNS
  module Manager
    class AbstractApiServlet < WEBrick::RouteServlet::ActionServlet
      def service(req, res)
        begin
          JSON.parse(req.body).each do |k,v|
            req.params[k.to_sym] = v
          end
        rescue
        end
          
        begin
          super
        ensure
          ActiveRecord::Base.connection.close
        end
      end

      def _permit_query(req, *keys)
        keys = keys.flatten
        req.params.select{|k,v| keys.include?(k.to_sym)}
      end

      def _output(req, res, obj)
        res.content_type = "application/json"
        if Exception===obj
          obj = {
            :message => obj.message,
            :backtrace => obj.backtrace
          }
        end
        res.body = obj.to_json
      end
    end
  end
end
