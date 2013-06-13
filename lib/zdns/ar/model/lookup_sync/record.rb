require 'zdns/ar/model/lookup'
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
              lookup = Lookup.where(lookup_conditions).first_or_initialize
              lookup.fqdn = lookup_fqdn
              lookup.save!
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
