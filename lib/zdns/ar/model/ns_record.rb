require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class NsRecord < ActiveRecord::Base
        include ActiveModel::ForbiddenAttributesProtection
        include Synchronizable::Record

        belongs_to :soa_record

        RDATA_FIELDS = [:nsdname]
      end
    end
  end
end
