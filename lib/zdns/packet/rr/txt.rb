require 'zdns/packet/rr/base'

module ZDNS
  class Packet
    module RR
      class TXT < Base
        attr_accessor :txt_data

        def type
          Type::TXT
        end

        def cls
          Class::IN
        end

        def build_rdata(result)
          [self.txt_data.length].pack("C") + self.txt_data
        end
      end
    end
  end
end
