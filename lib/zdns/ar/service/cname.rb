require 'zdns/ar/service/base'

module ZDNS
  module AR
    module Service
      class CNAME < Base
        def lookup_additionals
          return if @lookedup_additionals
          @lookedup_additionals = true

          # additionals
          @answers.each do |cname|
            # a
            service = A.new(cname.cname, Packet::Type::A)
            service.lookup
            @additionals.concat(service.answers)

            # aaaa
            service = AAAA.new(cname.cname, Packet::Type::AAAA)
            service.lookup
            @additionals.concat(service.answers)
          end
        end
      end
    end
  end
end
