require 'zdns/ar/model/lookup_sync'

module ZDNS
  module AR
    module Model
      class AaaaRecord < ActiveRecord::Base
        include LookupSync::Record

        attr_accessible :soa_record_id
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :address
        attr_accessible :enable_ptr

        belongs_to :soa_record

        RDATA_FIELDS = [:address]

        def address=(val)
          begin
            self[:address] = IPAddr.new(val, Socket::AF_INET6).to_s
          rescue => e
            self[:address] = val
          end
        end
      end
    end
  end
end
