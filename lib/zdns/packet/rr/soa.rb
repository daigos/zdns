require 'zdns/packet/rr/base'

module ZDNS
  class Packet
    module RR
      class SOA < Base
        domain_accessor :mname
        domain_accessor :rname
        long_accessor :serial
        long_accessor :refresh
        long_accessor :retry
        long_accessor :expire
        long_accessor :minimum

        def type
          Type::SOA
        end

        def cls
          Class::IN
        end

        def build_rdata(buf)
          buf.write_domain(self.mname.to_s)
          buf.write_domain(self.rname.to_s)
          buf.write_long(self.serial.to_i)
          buf.write_long(self.refresh.to_i)
          buf.write_long(self.retry.to_i)
          buf.write_long(self.expire.to_i)
          buf.write_long(self.minimum.to_i)
        end

        class << self
          def parse_rdata(buf)
            {
              :mname => buf.read_domain,
              :rname => buf.read_domain,
              :serial => buf.read_long,
              :refresh => buf.read_long,
              :retry => buf.read_long,
              :expire => buf.read_long,
              :minimum => buf.read_long,
            }
          end
        end
      end
    end
  end
end
