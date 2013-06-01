require 'zdns/packet/sym_num_constant'

module ZDNS
  class Packet
    class Class
      include SymNumConstant

      IN = regist :IN, 1
      CS = regist :CS, 2
      CH = regist :CH, 3
      HS = regist :HS, 4
    end
  end
end
