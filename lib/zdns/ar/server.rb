require 'zdns/server'
require 'zdns/ar/migrator'
require 'zdns/ar/model'

module ZDNS
  module AR
    class Server < ZDNS::Server
      def initialize(options={})
        super(options)
        AR.db_initialize(options[:database])
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
