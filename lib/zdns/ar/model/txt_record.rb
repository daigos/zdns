require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class TxtRecord < ActiveRecord::Base
        include Synchronizable::Record

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
