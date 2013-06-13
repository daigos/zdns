require 'zdns/ar/model/lookup_sync'

module ZDNS
  module AR
    module Model
      class CnameRecord < ActiveRecord::Base
        include LookupSync::Record

        attr_accessible :soa_record_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :cname

        belongs_to :soa_record
      end
    end
  end
end
