require 'zdns/packet/rr/base'
require 'zdns/packet/rr/a'
require 'zdns/packet/rr/ns'
require 'zdns/packet/rr/cname'
require 'zdns/packet/rr/soa'
require 'zdns/packet/rr/ptr'
require 'zdns/packet/rr/mx'
require 'zdns/packet/rr/txt'

module ZDNS
  class Packet
    module RR
      def new_from_buffer(buf)
        # name
        name = buf.read_name

        # type
        type = buf.read_type

        type.rr_class.parse_rdata(buf)
      end
    end
  end
end
