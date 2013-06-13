require 'zdns/ar/model/lookup_sync'

module ZDNS
  module AR
    module Model
      class SoaRecord < ActiveRecord::Base
        include LookupSync::Zone

        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :mname
        attr_accessible :rname
        attr_accessible :serial
        attr_accessible :refresh
        attr_accessible :retry
        attr_accessible :expire
        attr_accessible :minimum

        has_many :a_records
        has_many :ns_records
        has_many :cname_records
        has_many :mx_records
        has_many :txt_records
        has_many :aaaa_records
      end
    end
  end
end
