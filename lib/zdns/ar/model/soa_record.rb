require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class SoaRecord < ActiveRecord::Base
        include ActiveModel::ForbiddenAttributesProtection
        include Synchronizable::Zone

        has_many :a_records, :dependent => :destroy
        has_many :ns_records, :dependent => :destroy
        has_many :cname_records, :dependent => :destroy
        has_many :mx_records, :dependent => :destroy
        has_many :txt_records, :dependent => :destroy
        has_many :aaaa_records, :dependent => :destroy

        RDATA_FIELDS = [:mname, :rname, :serial, :refresh, :retry, :expire, :minimum]

        def to_bind
          lines = []

          lines << "$TTL #{self.ttl}"
          lines << ""

          lines << "; SOA Record"
          lines << "#{self.lookup_fqdn} IN SOA #{self.mname} #{self.rname} ("
          lines << sprintf("    %11d ; Serial Number", self.serial)
          lines << sprintf("    %11d ; Refresh Time", self.refresh)
          lines << sprintf("    %11d ; Retry Time", self.retry)
          lines << sprintf("    %11d ; Expire Time", self.expire)
          lines << sprintf("    %11d ; Cache Time", self.minimum)
          lines << ")"

          self.class.reflections.keys.each do |key|
            lines << ""
            record_type = key.to_s.sub("_records", "").upcase
            lines << "; #{record_type} Records"
            self.send(key).each do |record|
              lines << record.to_bind
            end
          end

          lines.join("\n")
        end
      end
    end
  end
end
