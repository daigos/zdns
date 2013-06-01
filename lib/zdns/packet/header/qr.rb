require 'zdns/packet/sym_num_constant'

module ZDNS
  class Packet
    class Header
      class QR
        include SymNumConstant

        QUERY    = regist :Query,    0
        RESPONSE = regist :Response, 1
      end
    end
  end
end
