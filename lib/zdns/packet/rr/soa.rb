require 'zdns/packet/rr/base'

module ZDNS
  class Packet
    module RR
      class SOA < Base
        attr_accessor :mname
        attr_accessor :rname
        attr_accessor :serial
        attr_accessor :refresh
        attr_accessor :retry
        attr_accessor :expire
        attr_accessor :minimum

        def type
          Type::SOA
        end

        def cls
          Class::IN
        end

        def build_rdata(buf)
          buf.write_domain(self.mname.to_s)
          buf.write_domain(self.rname.to_s)
          buf.write_int(self.serial.to_i)
          buf.write_int(self.refresh.to_i)
          buf.write_int(self.retry.to_i)
          buf.write_int(self.expire.to_i)
          buf.write_int(self.minimum.to_i)
        end

        class << self
          def parse_rdata(buf)
            {
              :mname => buf.read_domain,
              :rname => buf.read_domain,
              :serial => buf.read_int,
              :refresh => buf.read_int,
              :retry => buf.read_int,
              :expire => buf.read_int,
              :minimum => buf.read_int,
            }
          end
        end
      end
    end
  end
end
