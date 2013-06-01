require 'zdns/packet/sym_num_constant'

module ZDNS
  class Packet
    class Header
      class TC
        include SymNumConstant

        NON_TRUNCATION = regist :NonTruncation, 0
        TRUNCATION     = regist :Truncation,    1
      end
    end
  end
end
