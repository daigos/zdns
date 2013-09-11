require 'zdns/manager/abstract_api_servlet'
require 'zdns/ar/model'

module ZDNS
  module Manager
    class ApiAnyRecordServlet < AbstractApiServlet
      def show(req, res)
        ret = nil

        begin
          data = {}

          data["soa"] = AR::Model::SoaRecord.where(:id => req.params[:soa_record_id]).first

          AR::Model.get_models.each do |model|
            data[model.rr_name.downcase] = model.where(:soa_record_id => req.params[:soa_record_id]).load
          end

          ret = data
        rescue => e
          ret = e
        end

        _output req, res, ret
      end
    end
  end
end
