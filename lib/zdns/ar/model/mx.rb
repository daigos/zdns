require 'zdns/ar/model/lookup_sync'

module ZDNS
  module AR
    module Model
      class MX < ActiveRecord::Base
        include LookupSync

        attr_accessible :soa_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :preference
        attr_accessible :exchange

        belongs_to :soa
      end
    end
  end
end
