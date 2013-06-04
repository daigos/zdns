module ZDNS
  class Packet
    module RR
      module Accessor
        module Text
          protected
          def _text_writer(text)
            text = text.to_s
            len = text.length
            if len<1 || 0xFF<len
              raise FormatError, "text is not valid length: #{len}"
            end
            text
          end

          module ClassMethods
            def text_accessor(*keys)
              _rr_accessor(:text, keys)
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
