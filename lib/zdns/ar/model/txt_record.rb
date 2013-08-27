require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class TxtRecord < ActiveRecord::Base
        include ActiveModel::ForbiddenAttributesProtection
        include Synchronizable::Record

        belongs_to :soa_record

        RDATA_FIELDS = [:txt_data]
      end
    end
  end
end
