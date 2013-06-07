require 'zdns/ar/model/lookup_sync'

module ZDNS
  module AR
    module Model
      class TXT < ActiveRecord::Base
        include LookupSync

        attr_accessible :soa_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :txt_data

        belongs_to :soa
      end
    end
  end
end
