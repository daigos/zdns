require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class CnameRecord < ActiveRecord::Base
        include Synchronizable::Record

        attr_accessible :soa_record_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :cname

        belongs_to :soa_record

        RDATA_FIELDS = [:cname]
      end
    end
  end
end
