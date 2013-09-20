require 'webrick'
require 'webrick/route_servlet'
require 'zdns/manager/abstract_api_servlet'
require 'zdns/manager/api_zone_servlet'
require 'zdns/manager/api_record_servlet'
require 'zdns/manager/api_any_record_servlet'
require 'zdns/manager/api_not_found_servlet'

module ZDNS
  module Manager
    class Server
      attr_reader :config
      attr_accessor :logger

      def initialize(config={}, db_config=nil)
        @config = config

        if db_config
          AR.db_initialize(db_config)
        end
      end

      def start
        shutdown

        document_root = File.expand_path("./public", File.dirname(__FILE__))

        @server = WEBrick::HTTPServer.new(@config)
        @server.mount("/", WEBrick::HTTPServlet::FileHandler, document_root)
        @server.mount("/api", WEBrick::RouteServlet.servlet{|s|
          resources_only = [:index, :create, :show, :update, :destroy]
          resource_only = [:show, :update, :destroy]

          s.resources "/zone", ApiZoneServlet, :only => resources_only
          s.resource  "/zone/:soa_record_id/soa", ApiZoneServlet, :only => resource_only
          s.resources "/zone/:soa_record_id/:record_type", ApiRecordServlet, :only => resources_only, :record_type => /(a|ns|cname|mx|txt|aaaa|)/
          s.resource  "/zone/:soa_record_id/any", ApiAnyRecordServlet, :only => :show

          s.root ApiNotFoundServlet
          s.match "/*path", ApiNotFoundServlet
        })

        @server.start
      end

      def shutdown
        if @server
          @server.shutdown
          @server = nil
        end
      end
    end
  end
end
