require 'zdns/ar/model/forward_lookup'
require 'zdns/ar/model/validator'

module ZDNS
  module AR
    module Model
      module Synchronizable
        module Base
          # abstract methods

          def lookup_fqdn
            raise "abstract method: AR::Model::Synchronizable::Base.lookup_fqdn"
          end

          def lookup_conditions
            raise "abstract method: AR::Model::Synchronizable::Base.lookup_conditions"
          end

          def sync_lookup
            raise "abstract method: AR::Model::Synchronizable::Base.sync_lookup"
          end

          def delete_lookup
            ForwardLookup.where(lookup_conditions).delete_all
            ReverseLookup.where(lookup_conditions).delete_all
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

          # rr

          def to_rr(name)
            attr = self.attributes.dup

            # name
            attr.delete("name")

            # ttl
            ttl = attr.delete("ttl").to_i
            if ttl<=0
              ttl = self.soa_record.ttl.to_i
            end

            self.class.rr_class.new(name, ttl, attr)
          end

          def to_ptr_rr(name)
            Packet::RR::PTR.new(name, self.ttl, :ptrdname => lookup_fqdn)
          end

          module ClassMethods
            def rr_name
              self.name.split('::').last.sub("Record", "").upcase
            end

            def rr_type
              ZDNS::Packet::Type.from_sym(rr_name)
            end

            def rr_class
              rr_type.rr_class
            end

            def fqdn_match_lookups(fqdn)
              ForwardLookup.fqdn_match_lookups(fqdn, rr_type)
            end

            def where_fqdn(fqdn)
              ForwardLookup.where_fqdn(fqdn, self)
            end
          end
        end
      end
    end
  end
end
