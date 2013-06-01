require 'zdns/packet/rr/base'

module ZDNS
  class Packet
    module RR
      class A < Base
        attr_accessor :address

        def type
          Type::A
        end

        def cls
          Class::IN
        end

        def build_rdata(result)
          ip2bin(self.address)
        end
      end
    end
  end
end
