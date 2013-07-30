module ZDNS
  module AR
    module Model
      class ReverseLookup < ActiveRecord::Base
        attr_accessible :fqdn
        attr_accessible :soa_record_id
        attr_accessible :record_type
        attr_accessible :record_id

        class << self
          def fqdn_match_lookups(fqdn, rr_type)
            lookups = self.where(:fqdn => fqdn).where(:record_type => rr_type.to_i).all
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
