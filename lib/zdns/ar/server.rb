require 'fileutils'
require 'zdns/server'
require 'zdns/ar/migrator'
require 'zdns/ar/model'

module ZDNS
  module AR
    class Server < ZDNS::Server
      DEFAULT_AR_CONFIG = {
        :adapter => "sqlite3",
        :database  => ":memory:",
      }

      def initialize(options={})
        super(options)
        ar_config = DEFAULT_AR_CONFIG.merge(options[:activerecord] || {})
        ar_initialize(ar_config)
      end

      def ar_initialize(ar_config)
        if ar_config[:adapter]=="sqlite3" && ar_config[:database]!=":memory:"
          FileUtils.mkdir_p(File.dirname(ar_config[:database]))
        end

        # connect
        ActiveRecord::Base.establish_connection(ar_config)

        # migrate
        Migrator.migrate
      end

      def service(packet)
        begin
          super(packet)
        ensure
          ActiveRecord::Base.connection.close
        end
      end

      def lookup(packet)
        packet.questions.each do |question|
          service_cls = Service.from_type(question.type)
          service = service_cls.new(question.name, question.type)
          service.apply(packet)
        end
      end
    end
  end
end
