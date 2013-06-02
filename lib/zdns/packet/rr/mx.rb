require 'zdns/packet/rr/base'

module ZDNS
  class Packet
    module RR
      class MX < Base
        attr_accessor :preference
        attr_accessor :exchange

        def type
          Type::MX
        end

        def cls
          Class::IN
        end

        def build_rdata(result)
          [self.preference.to_i].pack("n") + compress_domain(result, self.exchange)
        end

        class << self
          def parse_rdata(buf)
            {
              :preference => buf.read_short,
              :exchange => buf.read_name,
            }
          end
        end
      end
    end
  end
end
