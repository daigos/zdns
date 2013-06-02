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

        def build_rdata(result)
          mname_bin = compress_domain(result, self.mname.to_s)
          rname_bin = compress_domain(result, self.rname.to_s)
          packed = [
            self.serial.to_i,
            self.refresh.to_i,
            self.retry.to_i,
            self.expire.to_i,
            self.minimum.to_i,
          ].pack("N5")

          mname_bin + rname_bin + packed
        end

        class << self
          def parse_rdata(buf)
            {
              :mname => buf.read_name,
              :rname => buf.read_name,
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
