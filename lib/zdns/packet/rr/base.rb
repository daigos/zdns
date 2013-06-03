require 'zdns/packet/type'
require 'zdns/packet/class'
require 'zdns/not_implemented'

module ZDNS
  class Packet
    module RR
      class Base
        attr_accessor :name
        attr_accessor :ttl

        def initialize(name, ttl, rdata={})
          @name = name.to_s
          @ttl = ttl.to_i

          rdata.each_pair do |key,value|
            setter = "#{key}="
            send(setter, rdata[key]) if respond_to?(setter)
          end
        end

        def build_rdata(result)
          raise NotImplemented, "#{self.class.name}.build_rdata is not implemented"
        end

        def to_bin(buf)
          buf.write_domain(self.name)
          buf.write_short(self.type.to_i)
          buf.write_short(self.cls.to_i)
          buf.write_int(self.ttl.to_i)

          # backup rdata length pos
          rdata_length_pos = buf.pos
          buf.write_short(0xFFFF)

          # write rdata
          build_rdata(buf)

          # write rdata length
          eof_pos = buf.pos
          buf.pos = rdata_length_pos
          buf.write_short(eof_pos - rdata_length_pos - 2)
          buf.pos = eof_pos

          buf
        end

        def to_hash
          instance_variables.inject({}) {|h,k|
            h.update({k.to_s.sub("@", "").to_sym => instance_variable_get(k)})
          }
        end

        def rdata_hash
          h = to_hash
          h.delete(:name)
          h.delete(:ttl)
          h
        end

        def ==(obj)
          self.class==obj.class && self.to_hash.reject{|k,v| v.nil?}==obj.to_hash.reject{|k,v| v.nil?}
        end

        class << self
          def parse_rdata(buf)
            raise NotImplemented, "#{self.name}.parse_rdata is not implemented"
          end
        end
      end
    end
  end
end
