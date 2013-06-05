module ZDNS
  module AR
    module Model
      class CNAME < ActiveRecord::Base
        attr_accessible :soa_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :cname

        belongs_to :soa
      end
    end
  end
end
