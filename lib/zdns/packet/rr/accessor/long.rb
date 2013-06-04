module ZDNS
  class Packet
    module RR
      module Accessor
        module Long
          protected
          def _long_writer(long)
            long = long.to_i
            if long<0 || 0xFFFFFFFF<long
              raise FormatError, "long is not valid range: #{long}"
            end
            long
          end

          module ClassMethods
            def long_accessor(*keys)
              _rr_accessor(:long, keys)
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
