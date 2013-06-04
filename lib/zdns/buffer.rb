require 'zdns/packet/type'
require 'zdns/packet/class'
require 'stringio'
require 'ipaddr'

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

    def read_domain
      read_labels.join(".")
    end

    def read_type
      Packet::Type.from_num(read_short)
    end

    def read_class
      Packet::Class.from_num(read_short)
    end

    def read_ipv4
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

    def read_long
      self.read(4).unpack("N")[0]
    end

    # write

    def domain_pos_hash
      @domain_pos_hash ||= {}
    end

    def write_domain(domain)
      # check format
      domain = domain.to_s.downcase
      unless domain.match(/^([a-z0-9\-]{1,191}\.)+$/)
        raise FormatError, "domain is not valid format: #{domain}"
      end

      labels = domain.split(".", -1)

      domain_bin = ""
      labels.each_with_index do |label, i|
        current_domain = labels[i..-1].join(".")

        domain_pos = domain_pos_hash[current_domain]
        if domain_pos
          # use cache
          domain_bin += [domain_pos | 0xC000].pack("n")
          break
        else
          # build label
          domain_pos_hash[current_domain] = self.pos + domain_bin.length
          domain_bin += [label.length].pack("C") + label
        end
      end

      self.write(domain_bin)
    end

    def write_ipv4(address)
      self.write_long(address)
    end

    def write_ipv6(address)
      ipaddr = IPAddr.new(address)
      self.write(ipaddr.hton)
    end

    # write integer

    def write_char(val)
      self.write([val.to_i].pack("C"))
    end

    def write_short(val)
      self.write([val.to_i].pack("n"))
    end

    def write_long(val)
      self.write([val.to_i].pack("N"))
    end
  end
end
