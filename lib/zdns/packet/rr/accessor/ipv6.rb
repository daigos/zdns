module ZDNS
  class Packet
    module RR
      module Accessor
        module IPv6
          protected
          def _ipv6_writer(ipv6)
            case ipv6
            when String
              begin
                ipv6 = IPAddr.new(ipv6)
              rescue => e
                raise FormatError, "ipv6 is not valid format: #{ipv6}"
              end
              unless ipv6.ipv6?
                raise FormatError, "ipv6 is not valid ipv6: #{ipv6}"
              end
              ipv6.to_s
            when IPAddr
              unless ipv6.ipv6?
                raise FormatError, "ipv6 is not valid ipv6: #{ipv6}"
              end
              ipv6.to_s
            else
              raise FormatError, "ipv6 type error: #{ipv6} (#{ipv6.class.name})"
            end
          end

          module ClassMethods
            def ipv6_accessor(*keys)
              _rr_accessor(:ipv6, keys)
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
