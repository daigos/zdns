module ZDNS
  class Packet
    module RR
      module Accessor
        module IPv4
          protected
          def _ipv4_writer(ipv4)
            case ipv4
            when Fixnum
              if ipv4<0 || 0xFFFFFFFF<ipv4
                raise FormatError, "ipv4 is not valid range: #{ipv4}"
              end
              [ipv4].pack("N").unpack("C4").inject(:to_s).join(".")
            when String
              unless "#{ipv4}.".match(/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){4}$/)
                raise FormatError, "ipv4 is not valid format: #{ipv4}"
              end
              ipv4.dup
            when IPAddr
              unless ipv4.ipv4?
                raise FormatError, "ipv4 is not valid ipv4: #{ipv4}"
              end
              ipv4.to_s
            else
              raise FormatError, "ipv4 type error: #{ipv4} (#{ipv4.class.name})"
            end
          end

          module ClassMethods
            def ipv4_accessor(*keys)
              _rr_accessor(:ipv4, keys)
            end
          end

          def self.included(klass)
            klass.extend ClassMethods
          end 
        end
      end
    end
  end
end
