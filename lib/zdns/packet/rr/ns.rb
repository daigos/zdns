require 'zdns/packet/rr/base'

module ZDNS
  class Packet
    module RR
      class NS < Base
        attr_accessor :nsdname

        def type
          Type::NS
        end

        def cls
          Class::IN
        end

        def build_rdata(buf)
          buf.write_domain(self.nsdname)
        end

        class << self
          def parse_rdata(buf)
            {
              :nsdname => buf.read_domain,
            }
          end
        end
      end
    end
  end
end
