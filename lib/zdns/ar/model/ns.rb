module ZDNS
  module AR
    module Model
      class NS < ActiveRecord::Base
        attr_accessible :soa_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :nsdname

        belongs_to :soa
      end
    end
  end
end
