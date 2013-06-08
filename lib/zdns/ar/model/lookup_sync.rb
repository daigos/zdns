require 'zdns/ar/model/lookup'
require 'zdns/ar/model/validator'

module ZDNS
  module AR
    module Model
      module LookupSync
        def lookup_fqdn
          if self.respond_to?(:soa_id)
            # not soa record
            if self.name=='@'
              self.soa.name
            else
              "#{self.name}.#{self.soa.name}"
            end
          else
            # soa record
            self.name
          end
        end

        def lookup_conditions
          conditions = {
            :soa_id => self.respond_to?(:soa_id) ? self.soa_id : self.id,
            :record_type => self.class.rr_type.to_i,
            :record_id => self.id,
          }
        end

        def create_or_update
          result = super

          if result
            # lookup create_or_update
            lookup = Lookup.where(lookup_conditions).first_or_initialize
            lookup.fqdn = lookup_fqdn
            lookup.save!
          end

          result
        end

        def destroy_associations
          if self.respond_to?(:soa_id)
            # not soa record
            Lookup.where(lookup_conditions).delete_all
          else
            # soa record
            conditions = lookup_conditios
            conditions.delete(:record_id)
            Lookup.where(conditions).delete_all
          end
        end

        def to_rr
          attr = self.attributes.dup

          # name
          attr.delete("name")
          name = self.lookup_fqdn

          # ttl
          ttl = attr.delete("ttl").to_i
          if ttl==0 && self.respond_to?(:soa_id)
            # not soa record
            ttl = self.soa.ttl.to_i
          end

          self.class.rr_class.new(name, ttl, attr)
        end

        module ClassMethods
          def rr_type
            type = self.name.split('::').last
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

        def self.included(klass)
          klass.extend ClassMethods
          
          klass.instance_eval {
            include ActiveModel::Validations
            validates_with Validator
          }
        end
      end
    end
  end
end
