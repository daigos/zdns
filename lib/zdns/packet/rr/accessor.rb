require 'ipaddr'
require 'zdns/format_error'
require 'zdns/packet/rr/accessor/label'
require 'zdns/packet/rr/accessor/domain'
require 'zdns/packet/rr/accessor/ipv4'
require 'zdns/packet/rr/accessor/ipv6'
require 'zdns/packet/rr/accessor/long'
require 'zdns/packet/rr/accessor/short'
require 'zdns/packet/rr/accessor/text'

module ZDNS
  class Packet
    module RR
      module Accessor
        module ClassMethods
          protected
          def _rr_accessor(type, keys)
            keys.each do |key|
              class_eval %{
                def #{key}=(val)
                  @#{key} = _#{type}_writer(val)
                end

                attr_reader :#{key}
              }
            end
          end
        end

        def self.included(klass)
          klass.extend ClassMethods
          klass.instance_eval {
            include Label
            include Domain
            include IPv4
            include IPv6
            include Long
            include Short
            include Text
          }
        end 
      end
    end
  end
end
