require 'zdns/packet/type'
require 'zdns/packet/class'
require 'stringio'

module ZDNS
  class Buffer < StringIO
    def read_labels
      labels = []
      loop do
        len = self.readbyte rescue 0
        labels << self.read(len)
        break if len==0
      end
      labels
    end

    def read_name
      read_labels.join(".")
    end

    def read_type
      type_num = self.read(2).unpack("n")[0]
      Packet::Type.from_num(type_num)
    end

    def read_class
      type_num = self.read(2).unpack("n")[0]
      Packet::Class.from_num(type_num)
    end
  end
end
