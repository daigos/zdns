module ZDNS
  module AR
    module Migrator
      class << self
        def migrate
          ActiveRecord::Migrator.migrate("#{File.dirname(__FILE__)}/migrate", nil)
        end
      end
    end
  end
end
