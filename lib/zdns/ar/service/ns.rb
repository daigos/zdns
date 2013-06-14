require 'zdns/ar/service/base'

module ZDNS
  module AR
    module Service
      class NS < Base
        def lookup_authorities
        end

        def lookup_additionals
          return if @lookedup_additionals
          @lookedup_additionals = true

          @answers.each do |ns|
            service = A.new(ns.nsdname, Packet::Type::A)
            service.lookup
            @additionals.concat(service.answers)
          end
        end
      end
    end
  end
end
