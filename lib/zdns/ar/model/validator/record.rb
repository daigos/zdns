module ZDNS
  module AR
    module Model
      module Validator
        class Record < ActiveModel::Validator
          def validate(record)
            rr = record.class.rr_class.allocate
            attr = record.attributes.dup

            # name
            name = attr.delete("name")
            rr.instance_eval {
              begin
                _label_writer(name)
              rescue => e
                record.errors[:name] << e.to_s
              end
            }

            # ttl rdata
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
