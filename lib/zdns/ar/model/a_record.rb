require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class ARecord < ActiveRecord::Base
        include Synchronizable::Record

        attr_accessible :soa_record_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :address
        attr_accessible :enable_ptr

        belongs_to :soa_record

        RDATA_FIELDS = [:address]
      end
    end
  end
end
