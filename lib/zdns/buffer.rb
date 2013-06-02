require 'zdns/packet/type'
require 'zdns/packet/class'
require 'stringio'

module ZDNS
  class Buffer < StringIO
    def read_labels
      labels = []
      loop do
        len = self.read_char

        if (len&192)==192
          # compression
          next_label_pos = ((len & 63) << 8) + self.read_char
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

    def read_ipv6
      self.read(16).unpack("n8").map{|x| x.to_s(16)}.join(":")
    end

    # read integer

    def read_char
      self.read(1).unpack("C")[0]
    end

    def read_short
      self.read(2).unpack("n")[0]
    end

    def read_int
      self.read(4).unpack("N")[0]
    end
  end
end
