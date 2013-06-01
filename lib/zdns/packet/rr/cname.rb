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
      end
    end
  end
end
