module ZDNS
  module AR
    module Model
      class SOA < ActiveRecord::Base
        attr_accessible :name
        attr_accessible :ttl
        attr_accessible :mname
        attr_accessible :rname
        attr_accessible :serial
        attr_accessible :refresh
        attr_accessible :retry
        attr_accessible :expire
        attr_accessible :minimum

        has_many :as
        has_many :ns
        has_many :cnames
        has_many :mxs
        has_many :txts
        has_many :aaaas
      end
    end
  end
end
