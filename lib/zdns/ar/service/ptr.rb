require 'zdns/ar/service/base'
require 'zdns/ar/model/reverse_lookup'

module ZDNS
  module AR
    module Service
      class PTR < Base
        def lookup_answers
          return if @lookedup_answers
          @lookedup_answers = true

          # record ids
          lookups = fqdn_match_lookups(@name)
          lookups_type_groups = lookups.group_by{|lookup| lookup.record_type}

          lookups_type_groups.each_pair do |record_type, lookups|
            model_class = Packet::Type.from_num(record_type).model_class
            record_ids = lookups.map{|f| f.record_id}

            if 0<record_ids.length
              # relation
              relation = model_class.where(:id => record_ids)

              # include soa
              relation = relation.includes(:soa_record)

              relation.each do |record|
                @answers << record.to_ptr_rr(@name)
              end
            end
          end
        end

        def lookup_authorities
        end

        def fqdn_match_lookups(fqdn, rr_type=nil)
          lookups = Model::ReverseLookup.where(:fqdn => fqdn).load
        end
      end
    end
  end
end
