require 'zdns/ar/model/forward_lookup'
require 'zdns/ar/model/lookup_sync/base'
require 'zdns/ar/model/validator'

module ZDNS
  module AR
    module Model
      module LookupSync
        module Record
          include Base

          def lookup_fqdn
            if self.name=='@'
              self.soa_record.name
            else
              "#{self.name}.#{self.soa_record.name}"
            end
          end

          def lookup_conditions
            conditions = {
              :soa_record_id => self.soa_record_id,
              :record_type => self.class.rr_type.to_i,
              :record_id => self.id,
            }
          end

          def sync_lookup
            # forward lookup
            lookup = ForwardLookup.where(lookup_conditions).first_or_initialize
            lookup.fqdn = lookup_fqdn
            lookup.save!

            # reverse lookup
            if self.respond_to?(:enable_ptr)
              if self.enable_ptr
                rev_lookup = ReverseLookup.where(lookup_conditions).first_or_initialize
                rev_lookup.fqdn = IPAddr.new(self.address).reverse+"."
                rev_lookup.save!
              else
                ReverseLookup.where(lookup_conditions).delete_all
              end
            end
          end

          def to_bind
            columns = []
            columns << self.name
            columns << "IN"
            columns << self.class.rr_type.to_s

            columns += self.class.rr_class.attribute_keys.map{|key|
              val = self.send(key).to_s
              if /\s/=~val
                val = "\"#{val}\""
              end
              val
            }

            columns.join("\t")
          end

          def self.included(klass)
            klass.extend Base::ClassMethods

            klass.instance_eval {
              include ActiveModel::Validations
              validates_with Validator::Record
            }
          end
        end
      end
    end
  end
end
