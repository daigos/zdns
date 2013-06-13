require 'zdns/ar/model/lookup'
require 'zdns/ar/model/validator'

module ZDNS
  module AR
    module Model
      module LookupSync
        module Base
          # abstract methods

          def lookup_fqdn
            raise "abstract method: AR::Model::LookupSync::Base.lookup_fqdn"
          end

          def lookup_conditions
            raise "abstract method: AR::Model::LookupSync::Base.lookup_conditions"
          end

          def sync_lookup
            raise "abstract method: AR::Model::LookupSync::Base.sync_lookup"
          end

          def delete_lookup
            Lookup.where(lookup_conditions).delete_all
          end

          # base methods

          def create_or_update
            result = super
            if result
              sync_lookup
            end
            result
          end

          def destroy_associations
            delete_lookup
          end

          def to_rr(name)
            attr = self.attributes.dup

            # name
            attr.delete("name")

            # ttl
            ttl = attr.delete("ttl").to_i

            self.class.rr_class.new(name, ttl, attr)
          end

          module ClassMethods
            def rr_type
              type = self.name.split('::').last.sub("Record", "").upcase
              ZDNS::Packet::Type.from_sym(type)
            end

            def rr_class
              rr_type.rr_class
            end

            def fqdn_match_lookups(fqdn)
              Lookup.fqdn_match_lookups(fqdn, rr_type)
            end

            def where_fqdn(fqdn)
              Lookup.where_fqdn(fqdn, self)
            end
          end
        end
      end
    end
  end
end
