require 'zdns/manager/abstract_api_servlet'
require 'zdns/ar/model'

module ZDNS
  module Manager
    class ApiZoneServlet < AbstractApiServlet
      def index(req, res)
        ret = nil

        begin
          ret = AR::Model::SoaRecord.all
        rescue => e
          ret = e
        end

        _output req, res, ret
      end

      def create(req, res)
        ret = nil

        begin
          attrs = _permit_query(req, AR::Model::SoaRecord::UPDATABLE_FIELDS)
          ret = AR::Model::SoaRecord.create!(attrs)
        rescue => e
          ret = e
        end

        _output req, res, ret
      end

      def show(req, res)
        ret = nil

        begin
          id = req.params[:id] || req.params[:soa_record_id]
          ret = AR::Model::SoaRecord.where(:id => id).first
        rescue => e
          ret = e
        end

        _output req, res, ret
      end

      def update(req, res)
        ret = nil

        begin
          id = req.params[:id] || req.params[:soa_record_id]
          record = AR::Model::SoaRecord.where(:id => id).first

          unless record
            raise WEBrick::HTTPStatus::NotFound, "Zone is not found"
          end

          attrs = _permit_query(req, AR::Model::SoaRecord::UPDATABLE_FIELDS)
          record.update_attributes!(attrs)
          ret = record

        rescue => e
          ret = e
        end

        _output req, res, ret
      end

      def destroy(req, res)
        ret = nil

        begin
          id = req.params[:id] || req.params[:soa_record_id]
          record = AR::Model::SoaRecord.where(:id => id).first

          unless record
            raise WEBrick::HTTPStatus::NotFound, "Zone is not found"
          end

          record.destroy!
          ret = record

        rescue => e
          ret = e
        end

        _output req, res, ret
      end
    end
  end
end
