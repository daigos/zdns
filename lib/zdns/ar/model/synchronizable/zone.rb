require 'zdns/ar/model/forward_lookup'
require 'zdns/ar/model/synchronizable/base'
require 'zdns/ar/model/validator'

module ZDNS
  module AR
    module Model
      module Synchronizable
        module Zone
          include Base

          def lookup_fqdn
            self.name
          end

          def lookup_conditions
            conditions = {
              :soa_record_id => self.id,
              :record_type => self.class.rr_type.to_i,
            }
          end

          def sync_lookup
            # soa
            lookup = ForwardLookup.where(lookup_conditions).first_or_initialize
            lookup.record_id = self.id
            lookup.fqdn = lookup_fqdn
            lookup.save!

            # records
            type_lookups_hash = ForwardLookup.where(:soa_record_id => self.id).inject({}){|h,lookup|
              h[lookup.record_type] ||= []
              h[lookup.record_type] << lookup.record_id
              h
            }
            type_lookups_hash.delete(Packet::Type::SOA.to_i)

            type_lookups_hash.each do |type, record_ids|
              model_class = Packet::Type.from_num(type).model_class
              model_class.where(:id => record_ids).map(&:sync_lookup)
            end
          end

          def self.included(klass)
            klass.extend Base::ClassMethods
            
            klass.instance_eval {
              include ActiveModel::Validations
              validates_with Validator::Zone
            }
          end
        end
      end
    end
  end
end
