module ZDNS
  module AR
    class Control
      def initialize(db_config)
        AR.db_initialize(db_config)
      end

      def list(args)
        puts "zone name"
        puts "--------------------"
        Model::SoaRecord.all.each do |soa|
          puts soa.name
        end
      end

      def export(zone_names=[])

        puts "; ZDNS export"

        reflection_keys = Model::SoaRecord.reflections.keys
        relation = Model::SoaRecord.includes(*reflection_keys)

        if 0<zone_names.length
          relation = relation.where(:name => zone_names)
        end

        relation.all.each do |soa|
          puts ";--------------------"
          puts
          puts soa.to_bind
        end
      end

      def add(zone, type, name, ttl, rdata)
      end

      def usage
        puts "Usage: #{File.basename($0)} subcommand [option ..]"
        puts "  subcommands:"
        puts "    list"
        puts "    export"
      end
    end
  end
end
