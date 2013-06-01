module ZDNS
  module Utils
    def build_domain(domain)
      domain = domain.split(".", -1) if String===domain
      domain << "" if domain.length==0
      domain.map{|label|
        [label.length].pack("C") + label
      }.join("")
    end

    def compress_domain(result, domain)
      domain = domain.split(".", -1) if String===domain
      domain << "" if domain.length==0
      rdata = ""

      domain.length.times do |i|
        pos = nil
        if 0<domain[0].length
          pos = result.index(build_domain(domain))
        end
        if pos
          rdata += [pos|49152].pack("n")
          break
        else
          label = domain.shift
          rdata += build_domain(label)
        end
      end

      pos = result.index(rdata)
      if pos
        [pos|49152].pack("n")
      else
        rdata
      end
    end

    def ip2bin(ip)
      ip.split(".").map{|x|x.to_i}.pack("C4")
    end
  end
end
