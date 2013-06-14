require 'zdns/ar/service/base'
require 'zdns/ar/service/a'
require 'zdns/ar/service/ns'
require 'zdns/ar/service/cname'

module ZDNS
  module AR
    module Service
      class << self
        def from_type(type)
          begin
            const_get(type.to_sym)
          rescue => e
            Base
          end
        end
      end
    end
  end
end
