module ZDNS
  class Packet
    module RR
      module Accessor
        module Label
          protected
          def _label_writer(label)
            label = label.to_s.downcase
            unless label.match(/^[a-z0-9\-]{1,191}$/)
              raise FormatError, "label is not valid format: #{label}"
            end
            label
          end

          module ClassMethods
            def label_accessor(*keys)
              _rr_accessor(:label, keys)
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
