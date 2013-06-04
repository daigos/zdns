module ZDNS
  class Packet
    module RR
      module Accessor
        module Domain
          protected
          def _domain_writer(domain)
            domain = domain.to_s.downcase
            unless domain.match(/^([a-z0-9\-]{1,191}\.)+$/)
              raise FormatError, "domain is not valid format: #{domain}"
            end

            domain
          end

          module ClassMethods
            def domain_accessor(*keys)
              _rr_accessor(:domain, keys)
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
