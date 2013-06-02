require 'zdns/packet/sym_num_constant'

module ZDNS
  class Packet
    class Class
      include SymNumConstant

      # CLASS values
      IN  = regist :IN,    1   # RFC 1035
      CS  = regist :CS,    2   # RFC 1035
      CH  = regist :CH,    3   # RFC 1035
      HS  = regist :HS,    4   # RFC 1035

      # QCLASS values
      ANY = regist :ANY, 255   # RFC 1035
    end
  end
end
