module ZDNS
  module AR
    module Model
      class MX < ActiveRecord::Base
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
