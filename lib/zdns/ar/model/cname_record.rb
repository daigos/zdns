require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class CnameRecord < ActiveRecord::Base
        include ActiveModel::ForbiddenAttributesProtection
        include Synchronizable::Record

        belongs_to :soa_record

        RDATA_FIELDS = [:cname]
      end
    end
  end
end
