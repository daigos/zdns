require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class ARecord < ActiveRecord::Base
        include ActiveModel::ForbiddenAttributesProtection
        include Synchronizable::Record

        belongs_to :soa_record

        RDATA_FIELDS = [:address]
      end
    end
  end
end
