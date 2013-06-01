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
      attr_accessor :flag_qr
      attr_accessor :flag_opcode
      attr_accessor :flag_aa
      attr_accessor :flag_tc
      attr_accessor :flag_rd
      attr_accessor :flag_ra
      attr_accessor :flag_z
      attr_accessor :flag_rcode
      attr_accessor :qdcount
      attr_accessor :ancount
      attr_accessor :nscount
      attr_accessor :arcount

      def query?
        self.flag_qr == QR::QUERY
      end

      def response?
        !query?
      end

      def query!
        self.flag_qr = QR::QUERY
      end

      def response!
        self.flag_qr = QR::RESPONSE
      end

      def to_bin
        flag = 0
        flag += self.flag_qr.to_i << 15
        flag += self.flag_opcode.to_i << 11
        flag += self.flag_aa.to_i << 10
        flag += self.flag_tc.to_i << 9
        flag += self.flag_rd.to_i << 8
        flag += self.flag_ra.to_i << 7
        flag += self.flag_z.to_i << 4
        flag += self.flag_rcode.to_i

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
          obj.flag_qr = QR.from_num(head[1]>>15 & 1)
          obj.flag_opcode = OPCode.from_num(head[1]>>11 & 15)
          obj.flag_aa = AA.from_num(head[1]>>10 & 1)
          obj.flag_tc = TC.from_num(head[1]>>9 & 1)
          obj.flag_rd = RD.from_num(head[1]>>8 & 1)
          obj.flag_ra = RA.from_num(head[1]>>7 & 1)
          obj.flag_z = head[1]>>4 & 7
          obj.flag_rcode = Rcode.from_num(head[1] & 15)
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
