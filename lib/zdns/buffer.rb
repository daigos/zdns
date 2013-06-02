require 'zdns/packet/type'
require 'zdns/packet/class'
require 'stringio'

module ZDNS
  class Buffer < StringIO
    def read_labels
      labels = []
      loop do
        len = self.readbyte rescue 0

        if (len&192)==192
          # compression
          next_label_pos = ((len & 63) << 8) + (self.readbyte rescue 0)
          bak_pos = self.pos

          self.pos = next_label_pos
          labels += read_labels
          self.pos = bak_pos
          break
        else
          # normal label
          labels << self.read(len)
          break if len==0
        end
      end
      labels
    end

    def read_name
      read_labels.join(".")
    end

    def read_type
      Packet::Type.from_num(read_short)
    end

    def read_class
      Packet::Class.from_num(read_short)
    end

    def read_ip
      self.read(4).unpack("C4").map{|x| x.to_s}.join(".")
    end

    def read_short
      self.read(2).unpack("n")[0]
    end

    def read_int
      self.read(4).unpack("N")[0]
    end
  end
end
