require 'zdns/ar/model/forward_lookup'

module ZDNS
  module AR
    module Service
      class Base
        attr_reader :name
        attr_reader :rr_type
        attr_reader :answers
        attr_reader :authorities
        attr_reader :additionals

        def initialize(name, rr_type)
          @name = name
          @rr_type = rr_type
          @answers = []
          @authorities = []
          @additionals = []
        end

        def apply(packet)
          lookup

          packet.answers.concat(@answers)
          packet.authorities.concat(@authorities)
          packet.additionals.concat(@additionals)
        end

        def lookup
          lookup_answers
          lookup_authorities
          lookup_additionals
        end

        def lookup_answers
          return if @lookedup_answers
          @lookedup_answers = true

          # record ids
          lookups = fqdn_match_lookups(@name, @rr_type.to_i)
          record_ids = lookups.map{|f| f.record_id}

          if 0<record_ids.length
            # relation
            relation = @rr_type.model_class.where(:id => record_ids)

            # include soa
            if relation.reflections[:soa_record]
              relation = relation.includes(:soa_record)
            end

            relation.each do |record|
              @answers << record.to_rr(@name)
            end
          end
        end

        def lookup_authorities
          return if @lookedup_authorities
          @lookedup_authorities = true

          if @answers.length==0
            name = @name.dup
            while 0<name.length
              service = NS.new(name, Packet::Type::NS)
              service.lookup
              @authorities.concat(service.answers)
              @additionals.concat(service.additionals)

              break if 0<service.answers.length
              name.sub!(/^[^\.]+\./, "")
            end
          end
        end

        def lookup_additionals
        end

        def fqdn_match_lookups(fqdn, rr_type)
          wild_fqdn = "*.#{fqdn}"
          parent_fqdn = fqdn.sub(/^[^\.]+\./, "")
          parent_wild_fqdn = "*.#{parent_fqdn}"

          domains = [fqdn, wild_fqdn, parent_wild_fqdn]
          lookups = Model::ForwardLookup.where(:fqdn => domains).where(:record_type => rr_type).load
          lookups_groups = lookups.group_by{|lookup| lookup.fqdn}

          domains.each do |domain|
            match_lookups = lookups_groups[domain]
            return match_lookups if match_lookups
          end
          []
        end
      end
    end
  end
end
