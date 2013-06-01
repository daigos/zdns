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

        def build_rdata(result)
          compress_domain(result, self.ptrdname)
        end
      end
    end
  end
end
