module ZDNS
  class Packet
    module RR
      module Accessor
        module Short
          protected
          def _short_writer(short)
            short = short.to_i
            if short<0 || 0xFFFF<short
              raise FormatError, "short is not valid range: #{short}"
            end
            short
          end

          module ClassMethods
            def short_accessor(*keys)
              _rr_accessor(:short, keys)
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
