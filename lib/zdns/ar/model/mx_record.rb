require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class MxRecord < ActiveRecord::Base
        include ActiveModel::ForbiddenAttributesProtection
        include Synchronizable::Record

        belongs_to :soa_record

        RDATA_FIELDS = [:preference, :exchange]
      end
    end
  end
end
