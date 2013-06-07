require 'zdns/ar/model/lookup_sync'

module ZDNS
  module AR
    module Model
      class A < ActiveRecord::Base
        include LookupSync

        attr_accessible :soa_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :ip
        attr_accessible :enable_ptr

        belongs_to :soa, :class_name => "SOA"
      end
    end
  end
end
