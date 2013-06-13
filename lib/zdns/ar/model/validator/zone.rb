module ZDNS
  module AR
    module Model
      module Validator
        class Zone < ActiveModel::Validator
          def validate(record)
            rr = record.class.rr_class.allocate
            attr = record.attributes.dup

            # name ttl rdata
            attr.each_pair do |key,value|
              setter = "#{key}="
              begin
                rr.send(setter, value) if rr.respond_to?(setter)
              rescue => e
                record.errors[key.to_sym] << e.to_s
              end
            end
          end
        end
      end
    end
  end
end
