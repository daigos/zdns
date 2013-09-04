require 'zdns/manager/abstract_api_servlet'
require 'zdns/ar/model'

module ZDNS
  module Manager
    class ApiAnyRecordServlet < AbstractApiServlet
      def show(req, res)
        data = {}

        data["soa"] = AR::Model::SoaRecord.where(:id => req.params[:zone_id]).first

        AR::Model.get_models(true).each do |model|
          data[model.rr_name.downcase] = model.where(:soa_record_id => req.params[:zone_id]).all
        end

        _output req, res, data
      end
    end
  end
end
