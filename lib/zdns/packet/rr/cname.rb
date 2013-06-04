require 'zdns/packet/rr/base'

module ZDNS
  class Packet
    module RR
      class CNAME < Base
        domain_accessor :cname

        def type
          Type::CNAME
        end

        def cls
          Class::IN
        end

        def build_rdata(buf)
          buf.write_domain(self.cname)
        end

        class << self
          def parse_rdata(buf)
            {
              :cname => buf.read_domain,
            }
          end
        end
      end
    end
  end
end
