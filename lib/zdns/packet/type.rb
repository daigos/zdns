require 'zdns/packet/sym_num_constant'
require 'zdns/packet/rr'
require 'zdns/ar/model'
require 'zdns/not_implemented'

module ZDNS
  class Packet
    class Type
      include SymNumConstant

      # Resource records
      A          = regist :A,           1   # RFC 1035
      NS         = regist :NS,          2   # RFC 1035
      MD         = regist :MD,          3   # RFC 1035
      MF         = regist :MF,          4   # RFC 1035
      CNAME      = regist :CNAME,       5   # RFC 1035
      SOA        = regist :SOA,         6   # RFC 1035, RFC 2308
      MB         = regist :MB,          7   # RFC 1035
      MG         = regist :MG,          8   # RFC 1035
      MR         = regist :MR,          9   # RFC 1035
      NULL       = regist :NULL,       10   # RFC 1035
      WKS        = regist :WKS,        11   # RFC 1035
      PTR        = regist :PTR,        12   # RFC 1035
      HINFO      = regist :HINFO,      13   # RFC 1035
      MINFO      = regist :MINFO,      14   # RFC 1035
      MX         = regist :MX,         15   # RFC 1035
      TXT        = regist :TXT,        16   # RFC 1035
      RP         = regist :RP,         17   # RFC 1183
      AFSDB      = regist :AFSDB,      18   # RFC 1183
      SIG        = regist :SIG,        24   # RFC 2535
      KEY        = regist :KEY,        25   # RFC 2535, RFC 2930
      AAAA       = regist :AAAA,       28   # RFC 3596
      LOC        = regist :LOC,        29   # RFC 1876
      SRV        = regist :SRV,        33   # RFC 2782
      NAPTR      = regist :NAPTR,      35   # RFC 3403
      KX         = regist :KX,         36   # RFC 2230
      CERT       = regist :CERT,       37   # RFC 4398
      DNAME      = regist :DNAME,      39   # RFC 2672
      APL        = regist :APL,        42   # RFC 3123
      DS         = regist :DS,         43   # RFC 4034
      SSHFP      = regist :SSHFP,      44   # RFC 4255
      IPSECKEY   = regist :IPSECKEY,   45   # RFC 4025
      RRSIG      = regist :RRSIG,      46   # RFC 4034
      NSEC       = regist :NSEC,       47   # RFC 4034
      DNSKEY     = regist :DNSKEY,     48   # RFC 4034
      DHCID      = regist :DHCID,      49   # RFC 4701
      NSEC3      = regist :NSEC3,      50   # RFC 5155
      NSEC3PARAM = regist :NSEC3PARAM, 51   # RFC 5155
      TLSA       = regist :TLSA,       52   # RFC 6698
      HIP        = regist :HIP,        55   # RFC 5205
      SPF        = regist :SPF,        99   # RFC 4408
      TKEY       = regist :TKEY,      249   # RFC 2930
      TSIG       = regist :TSIG,      250   # RFC 2845
      CAA        = regist :CAA,       257   # RFC 6844
      TA         = regist :TA,      32768
      DLV        = regist :DLV,     32769   # RFC 4431

      # Other types and pseudo resource records
      OPT        = regist :OPT,        41   # RFC 2671
      IXFR       = regist :IXFR,      251   # RFC 1996
      AXFR       = regist :AXFR,      252   # RFC 1035
      MAILB      = regist :MAILB,     253   # RFC 1035
      MAILA      = regist :MAILA,     254   # RFC 1035
      ANY        = regist :ANY,       255   # RFC 1035

      def rr_class
        begin
          ZDNS::Packet::RR.const_get(to_sym)
        rescue => e
          raise NotImplemented, "RR is not implemented: name: #{to_sym}, num: #{to_i}"
        end
      end

      def model_class
        begin
          ZDNS::AR::Model.const_get(to_sym)
        rescue => e
          raise NotImplemented, "Model is not implemented: name: #{to_sym}, num: #{to_i}"
        end
      end
    end
  end
end
