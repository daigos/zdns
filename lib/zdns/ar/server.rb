require 'fileutils'
require 'zdns/server'
require 'zdns/ar/model'

module ZDNS
  module AR
    class Server < ZDNS::Server
      attr_reader :host
      attr_reader :port
      attr_accessor :logger

      DEFAULT_AR_CONFIG = {
        :adapter => "sqlite3",
        :database  => "/var/zdns/zdns.db",
      }

      def initialize(options={})
        super(options)
        ar_config = DEFAULT_AR_CONFIG.merge(options[:active_record] || {})
        ar_initialize(ar_config)
      end

      def ar_initialize(ar_config)
        if ar_config[:adapter]=="sqlite3" && ar_config[:database]
          FileUtils.mkdir_p(File.dirname(ar_config[:database]))
        end

        # connect
        ActiveRecord::Base.establish_connection(ar_config)

        # migrate
        ActiveRecord::Migrator.migrate("#{File.dirname(__FILE__)}/migrate", nil)
      end

      def lookup(packet)
        packet.questions.each do |question|
          # answers
          lookup_answers(question).each do |answer|
            packet.answers << answer
          end

          # authorities
          lookup_authorities(question).each do |authority|
            packet.authorities << authority

            # additionals
            lookup_additionals(authority).each do |additional|
              packet.additionals << additional
            end
          end
        end
      end

      def lookup_answers(question)
        []
      end

      def lookup_authorities(question)
        []
      end

      def lookup_additionals(authority)
        []
      end
    end
  end
end
