require 'zdns/packet/sym_num_constant'

module ZDNS
  class Packet
    class Header
      class OPCode
        include SymNumConstant

        STANDARD_QUERY         = regist :StandardQuery,        0
        INVERSE_QUERY          = regist :InverseQuery,         1
        SERVER_STATUS_REQUEST  = regist :ServerStatusRequest,  2
      end
    end
  end
end
