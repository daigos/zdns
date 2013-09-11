require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class ARecord < ActiveRecord::Base
        include ActiveModel::ForbiddenAttributesProtection
        include Synchronizable::Record

        belongs_to :soa_record

        RDATA_FIELDS = [:address]
        UPDATABLE_FIELDS = [:name, :ttl] + RDATA_FIELDS + [:enable_ptr]
      end
    end
  end
end
