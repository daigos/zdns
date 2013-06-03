require 'zdns/packet/rr/base'

module ZDNS
  class Packet
    module RR
      class PTR < Base
        attr_accessor :ptrdname
        def type
          Type::PTR
        end

        def cls
          Class::IN
        end

        def build_rdata(buf)
          buf.write_domain(self.ptrdname)
        end

        class << self
          def parse_rdata(buf)
            {
              :ptrdname => buf.read_domain,
            }
          end
        end
      end
    end
  end
end
