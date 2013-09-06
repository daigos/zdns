require 'zdns/ar/model/a_record'
require 'zdns/ar/model/ns_record'
require 'zdns/ar/model/cname_record'
require 'zdns/ar/model/soa_record'
require 'zdns/ar/model/mx_record'
require 'zdns/ar/model/txt_record'
require 'zdns/ar/model/aaaa_record'
require 'zdns/ar/model/forward_lookup'
require 'zdns/ar/model/reverse_lookup'
require 'zdns/ar/model/synchronizable'

module ZDNS
  module AR
    module Model
      class << self
        def get_model(record_type, include_soa=false)
          model_name = "#{record_type.to_s.capitalize}Record"
          if !include_soa && model_name=="SoaRecord"
            raise NameError, "wrong constant name #{model_name}"
          end
          const_get(model_name)
        end

        def get_models(include_soa=false)
          constants.select{|x|
            x.to_s.end_with?("Record")
          }.tap{|model_names|
            unless include_soa
              model_names.delete(:SoaRecord)
            end
          }.map{|model_name|
            const_get(model_name)
          }
        end
      end
    end
  end
end
