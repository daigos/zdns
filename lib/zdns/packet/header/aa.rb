require 'zdns/packet/sym_num_constant'

module ZDNS
  class Packet
    class Header
      class AA
        include SymNumConstant

        NON_AUTHORITATIVE_ANSWER = regist :NonAuthoritativeAnswer, 0
        AUTHORITATIVE_ANSWER     = regist :AuthoritativeAnswer,    1
      end
    end
  end
end
