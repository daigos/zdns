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

        def build_rdata(buf)
          buf.write_ipv4(self.address)
        end

        class << self
          def parse_rdata(buf)
            {
              :address => buf.read_ipv4,
            }
          end
        end
      end
    end
  end
end
