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

        def build_rdata(buf)
          buf.write_short(self.preference.to_i)
          buf.write_domain(self.exchange)
        end

        class << self
          def parse_rdata(buf)
            {
              :preference => buf.read_short,
              :exchange => buf.read_domain,
            }
          end
        end
      end
    end
  end
end
