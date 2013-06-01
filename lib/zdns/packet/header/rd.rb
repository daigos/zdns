require 'zdns/packet/sym_num_constant'

module ZDNS
  class Packet
    class Header
      class RD
        include SymNumConstant

        NON_RECURSION = regist :NonRecursion, 0
        RECURSION     = regist :Recursion,    1
      end
    end
  end
end
