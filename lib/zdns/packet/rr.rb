require 'zdns/packet/rr/base'
require 'zdns/packet/rr/a'
require 'zdns/packet/rr/ns'
require 'zdns/packet/rr/cname'
require 'zdns/packet/rr/soa'
require 'zdns/packet/rr/ptr'
require 'zdns/packet/rr/mx'
require 'zdns/packet/rr/txt'
require 'zdns/packet/rr/aaaa'
require 'zdns/format_error'

module ZDNS
  class Packet
    module RR
      class << self
        def new_from_buffer(buf)
          # name
          name = buf.read_domain

          # type
          type = buf.read_type

          # class
          cls = buf.read_class

          # ttl
          ttl = buf.read_long

          # rdata length
          rdata_len = buf.read_short

          # rdata
          rr_class = type.rr_class
          before_rdata_pos = buf.pos
          rdata = rr_class.parse_rdata(buf)

          # check read rdata length
          unless buf.pos==before_rdata_pos+rdata_len
            raise FormatError, "invalid read #{type.to_s}(#{type.to_i}) rdata length"
          end

          rr_class.new(name, ttl, rdata)
        end
      end
    end
  end
end
