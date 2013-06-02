require 'zdns/packet/header/qr'
require 'zdns/packet/header/opcode'
require 'zdns/packet/header/aa'
require 'zdns/packet/header/tc'
require 'zdns/packet/header/rd'
require 'zdns/packet/header/ra'
require 'zdns/packet/header/rcode'

module ZDNS
  class Packet
    class Header
      attr_accessor :id

      attr_accessor :qr
      attr_accessor :opcode
      attr_accessor :aa
      attr_accessor :tc
      attr_accessor :rd
      attr_accessor :ra
      attr_accessor :z
      attr_accessor :rcode

      attr_accessor :qdcount
      attr_accessor :ancount
      attr_accessor :nscount
      attr_accessor :arcount

      def initialize
        @id = 0

        @qr = QR.from_num(0)
        @opcode = OPCode.from_num(0)
        @aa = AA.from_num(0)
        @tc = TC.from_num(0)
        @rd = RD.from_num(0)
        @ra = RA.from_num(0)
        @z = 0
        @rcode = Rcode.from_num(0)

        @qdcount = 0
        @ancount = 0
        @nscount = 0
        @arcount = 0
      end

      def query?
        self.qr == QR::QUERY
      end

      def response?
        !query?
      end

      def query!
        self.qr = QR::QUERY
      end

      def response!
        self.qr = QR::RESPONSE
      end

      def to_bin
        flag = 0
        flag += self.qr.to_i << 15
        flag += self.opcode.to_i << 11
        flag += self.aa.to_i << 10
        flag += self.tc.to_i << 9
        flag += self.rd.to_i << 8
        flag += self.ra.to_i << 7
        flag += self.z.to_i << 4
        flag += self.rcode.to_i

        [
          self.id.to_i,
          flag,
          self.qdcount.to_i,
          self.ancount.to_i,
          self.nscount.to_i,
          self.arcount.to_i,
        ].pack("n6")
      end

      class << self
        def new_from_buffer(buf)
          head = buf.read(12).unpack("n*")

          obj = new
          obj.id = head[0]

          obj.qr = QR.from_num(head[1]>>15 & 1)
          obj.opcode = OPCode.from_num(head[1]>>11 & 15)
          obj.aa = AA.from_num(head[1]>>10 & 1)
          obj.tc = TC.from_num(head[1]>>9 & 1)
          obj.rd = RD.from_num(head[1]>>8 & 1)
          obj.ra = RA.from_num(head[1]>>7 & 1)
          obj.z = head[1]>>4 & 7
          obj.rcode = Rcode.from_num(head[1] & 15)

          obj.qdcount = head[2]
          obj.ancount = head[3]
          obj.nscount = head[4]
          obj.arcount = head[5]

          obj
        end
      end
    end
  end
end
