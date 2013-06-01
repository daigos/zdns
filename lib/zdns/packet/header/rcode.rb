require 'zdns/packet/sym_num_constant'

module ZDNS
  class Packet
    class Header
      class Rcode
        include SymNumConstant

        NO_ERROR        = regist :NoError,        0
        FORMAT_ERROR    = regist :FormatError,    1
        SERVER_FAILURE  = regist :ServerFailure,  2
        NAME_ERROR      = regist :NameError,      3
        NOT_IMPLEMENTED = regist :NotImplemented, 4
        REFUSED         = regist :Refused,        5
      end
    end
  end
end
