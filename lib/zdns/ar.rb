require 'active_record'
require 'fileutils'
require 'zdns/ar/migrator'
require 'zdns/ar/server'
require 'zdns/ar/service'
require 'zdns/ar/model'
require 'zdns/ar/control'

module ZDNS
  module AR
    DEFAULT_DB_CONFIG = {
      :adapter => "sqlite3",
      :database  => ":memory:",
    }

    class << self
      def db_initialize(db_config)
        db_config = DEFAULT_DB_CONFIG.merge(db_config || {})

        if db_config[:adapter]=="sqlite3" && db_config[:database]!=":memory:"
          FileUtils.mkdir_p(File.dirname(db_config[:database]))
        end

        # connect
        ActiveRecord::Base.establish_connection(db_config)

        # migrate
        Migrator.migrate
      end
    end
  end
end
