require 'zdns/ar/service/base'

module ZDNS
  module AR
    module Service
      class A < Base
        def lookup_answers
          return if @lookedup_answers
          @lookedup_answers = true

          # record ids
          lookups = fqdn_match_lookups(@name, [@rr_type.to_i, Packet::Type::CNAME.to_i])
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
                @answers << record.to_rr(@name)
              end
            end
          end
        end
      end
    end
  end
end
