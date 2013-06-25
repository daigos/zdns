require 'zdns/ar/model/lookup_sync'

module ZDNS
  module AR
    module Model
      class TxtRecord < ActiveRecord::Base
        include LookupSync::Record

        attr_accessible :soa_record_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :txt_data

        belongs_to :soa_record

        RDATA_FIELDS = [:txt_data]
      end
    end
  end
end
