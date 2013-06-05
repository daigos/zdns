module ZDNS
  module AR
    module Model
      class A < ActiveRecord::Base
        attr_accessible :soa_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :ip
        attr_accessible :enable_ptr

        belongs_to :soa
      end
    end
  end
end
