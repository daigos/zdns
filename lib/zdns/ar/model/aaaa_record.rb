require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class AaaaRecord < ActiveRecord::Base
        include ActiveModel::ForbiddenAttributesProtection
        include Synchronizable::Record

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
