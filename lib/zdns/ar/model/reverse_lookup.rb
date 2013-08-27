require 'active_record'

module ZDNS
  module AR
    module Model
      class ReverseLookup < ActiveRecord::Base
        include ActiveModel::ForbiddenAttributesProtection

        class << self
          def fqdn_match_lookups(fqdn, rr_type)
            lookups = self.where(:fqdn => fqdn).where(:record_type => rr_type.to_i).load
          end

          def where_fqdn(fqdn, rr_type)
            # record ids
            lookups = self.fqdn_match_lookups(fqdn, rr_type)
            record_ids = lookups.map{|f| f.record_id}

            # relation
            relation = rr_type.model_class.where(:id => record_ids)

            # join soa
            if relation.reflections[:soa]
              relation = relation.includes(:soa)
            end

            relation
          end
        end
      end
    end
  end
end
