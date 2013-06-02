require 'zdns/packet/sym_num_constant'
require 'zdns/packet/rr'
require 'zdns/not_implemented'

module ZDNS
  class Packet
    class Type
      include SymNumConstant

      A     = regist :A,       1
      NS    = regist :NS,      2
      MD    = regist :MD,      3
      MF    = regist :MF,      4
      CNAME = regist :CNAME,   5
      SOA   = regist :SOA,     6
      MB    = regist :MB,      7
      MG    = regist :MG,      8
      MR    = regist :MR,      9
      NULL  = regist :NULL,   10
      WKS   = regist :WKS,    11
      PTR   = regist :PTR,    12
      HINFO = regist :HINFO,  13
      MINFO = regist :MINFO,  14
      MX    = regist :MX,     15
      TXT   = regist :TXT,    16
      AXFR  = regist :AXFR,  252
      MAILB = regist :MAILB, 253
      MAILA = regist :MAILA, 254
      ANY   = regist :ANY,   255

      def rr_class
        begin
          ZDNS::Packet::RR.const_get(to_sym)
        rescue => e
          raise NotImplemented, "RR is not implemented: name: #{to_sym}, num: #{to_i}"
        end
      end
    end
  end
end
