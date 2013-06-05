module ZDNS
  module AR
    module Model
      class TXT < ActiveRecord::Base
        attr_accessible :soa_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :txt_data

        belongs_to :soa
      end
    end
  end
end
