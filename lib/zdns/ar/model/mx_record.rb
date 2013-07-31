require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class MxRecord < ActiveRecord::Base
        include Synchronizable::Record

        attr_accessible :soa_record_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :preference
        attr_accessible :exchange

        belongs_to :soa_record

        RDATA_FIELDS = [:preference, :exchange]
      end
    end
  end
end
