require 'zdns/packet/rr/base'

module ZDNS
  class Packet
    module RR
      class CNAME < Base
        attr_accessor :cname

        def type
          Type::CNAME
        end

        def cls
          Class::IN
        end

        def build_rdata(result)
          compress_domain(result, self.cname)
        end

        class << self
          def parse_rdata(buf)
            {
              :cname => buf.read_name,
            }
          end
        end
      end
    end
  end
end
