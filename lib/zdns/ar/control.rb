require 'zdns/ar/control_error'

module ZDNS
  module AR
    class Control
      def initialize(db_config)
        AR.db_initialize(db_config)
      end

      def list(*args)
        puts "zone name"
        puts "--------------------"
        Model::SoaRecord.all.each do |soa|
          puts soa.name
        end
      end

      def export(*zone_names)
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

      def add_zone(zone_name=nil, ttl=nil, *rdata)
        # attrs
        columns = Model::SoaRecord.columns[1..-1].map(&:name)
        values = [zone_name, ttl] + rdata
        attrs = Hash[columns.zip(values)]

        unless columns.length==values.length
          raise ControlError, "wrong number of zone arguments (#{values.length} for #{columns.length})"
        end

        # check exists
        if Model::SoaRecord.where(:name => zone_name).first
          raise ControlError, "zone is already exists: #{zone_name}"
        end

        # insert
        record = Model::SoaRecord.new(attrs)
        record.save!

        puts "inserted."
        p record
      end

      def add_record(zone_name, record_type, name, ttl, *rdata)
        # record_type
        record_types = ["a", "ns", "cname", "mx", "txt", "aaaa"]
        unless record_types.include?(record_type.to_s.downcase)
          raise ControlError, "record_type is not valid: #{record_type}"
        end

        # attrs
        record_cls = Model.const_get("#{record_type.to_s.capitalize}Record")
        columns = record_cls.columns[2..-1].map(&:name)
        values = [name, ttl] + rdata
        attrs = Hash[columns.zip(values)]

        unless columns.length==values.length
          raise ControlError, "wrong number of record arguments (#{values.length} for #{columns.length})"
        end

        # zone
        soa = Model::SoaRecord.where(:name => zone_name).first
        unless soa
          raise ControlError, "zone is not exists: #{zone_name}"
        end
        attrs["soa_record_id"] = soa.id

        # check exists
        if record_cls.where(attrs).first
          raise ControlError, "record is already exists: #{attrs}"
        end

        # insert
        record = record_cls.new(attrs)
        record.save!

        puts "inserted."
        p record
      end

      # help

      def help(method=nil, *args)
        if respond_to?("help_#{method}")
          send("help_#{method}", *args)
        else
          send("help_all", *args)
        end
      end

      def help_all(*args)
        puts "Usage:"
        puts "  #{File.basename($0)} <subcommand> [option ..]"
        puts
        puts "subcommands:"
        puts "  list"
        puts "  export"
        puts "  add_zone"
        puts "  add_record"
        puts "  help"
      end

      def help_add_zone(*args)
        columns = Model::SoaRecord.columns[1..-1]

        cmd_args = columns.map{|v| "<#{v.name.to_s}>"}.join(" ")

        puts "Usage:"
        puts "  #{File.basename($0)} add_zone #{cmd_args}"
        puts
        puts "args:"
        columns.each do |column|
          printf "  %-12s %s\n", column.name, column.type
        end
      end

      def help_add_record(*args)
        # record_types
        record_types = ["a", "ns", "cname", "mx", "txt", "aaaa"]
        tmp_record_types = record_types.select{|t| args.include?(t)}
        if 0<tmp_record_types.length
          record_types = tmp_record_types
        end

        # init
        usages = []
        args = []

        record_types.each do |record_type|
          record_cls = Model.const_get("#{record_type.to_s.capitalize}Record")
          columns = record_cls.columns[2..-1]

          # usage
          cmd_args = columns.map{|v| "<#{v.name.to_s}>"}.join(" ")
          usages << "  #{File.basename($0)} add_record <zone_name> #{record_type} #{cmd_args}"

          # args
          args << "#{record_type} args:\n" + columns.map{|column|
            sprintf("  %-12s %s\n", column.name, column.type)
          }.join
        end

        # print
        puts "Usage:"
        usages.each do |usage|
          puts usage
        end
        args.each do |arg|
          puts
          puts arg
        end
      end

      def method_missing(action, *args)
        help
      end
    end
  end
end
