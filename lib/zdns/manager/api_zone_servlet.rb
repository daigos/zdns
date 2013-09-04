require 'zdns/manager/abstract_api_servlet'
require 'zdns/ar/model'

module ZDNS
  module Manager
    class ApiZoneServlet < AbstractApiServlet
      def index(req, res)
        _output req, res, AR::Model::SoaRecord.all
      end

      def create(req, res)
        attrs = _permit_query(req, [:name, :ttl]+AR::Model::SoaRecord::RDATA_FIELDS)
        ret = nil
        begin
          ret = AR::Model::SoaRecord.create!(attrs)
        rescue => e
          res.status = 500
          ret = e
        end
        _output req, res, ret
      end

      def show(req, res)
        id = req.params[:id] || req.params[:zone_id]
        _output req, res, AR::Model::SoaRecord.where(:id => id).first
      end

      def update(req, res)
        id = req.params[:id] || req.params[:zone_id]
        attrs = _permit_query(req, [:name, :ttl]+AR::Model::SoaRecord::RDATA_FIELDS)
        record = AR::Model::SoaRecord.where(:id => id).first
        ret = record
        if record
          begin
            record.update_attributes!(attrs)
            ret = attrs
          rescue => e
            res.status = 500
            ret = e
          end
        else
          res.status = 404
          ret = {}
        end
        _output req, res, ret
      end

      def destroy(req, res)
        id = req.params[:id] || req.params[:zone_id]
        record = AR::Model::SoaRecord.where(:id => id).first
        ret = record
        if record
          begin
            record.destroy!
          rescue => e
            res.status = 500
            ret = e
          end
        else
          res.status = 404
          ret = {}
        end
        _output req, res, ret
      end
    end
  end
end
