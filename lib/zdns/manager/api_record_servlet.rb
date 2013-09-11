module ZDNS
  module Manager
    class ApiRecordServlet < AbstractApiServlet
      def index(req, res)
        ret = nil

        begin
          model_cls = AR::Model.get_model(req.params[:record_type])
          ret = model_cls.where(:soa_record_id => req.params[:soa_record_id]).load
        rescue => e
          ret = e
        end

        _output req, res, ret
      end

      def create(req, res)
        ret = nil

        begin
          # check zone
          unless AR::Model::SoaRecord.where(:id => req.params[:soa_record_id]).first
            raise WEBrick::HTTPStatus::NotFound, "Zone is not defined"
          end

          # create record
          model_cls = AR::Model.get_model(req.params[:record_type])
          attrs = _permit_query(req, [:soa_record_id]+model_cls::UPDATABLE_FIELDS)
          ret = model_cls.create!(attrs)
        rescue => e
          ret = e
        end

        _output req, res, ret
      end

      def show(req, res)
        ret = nil

        begin
          model_cls = AR::Model.get_model(req.params[:record_type])
          ret = model_cls.where({
            :soa_record_id => req.params[:soa_record_id],
            :id => req.params[:id],
          }).first
        rescue => e
          ret = e
        end

        _output req, res, ret
      end

      def update(req, res)
        ret = nil

        begin
          model_cls = AR::Model.get_model(req.params[:record_type])
          record = model_cls.where({
            :soa_record_id => req.params[:soa_record_id],
            :id => req.params[:id],
          }).first

          unless record
            raise WEBrick::HTTPStatus::NotFound, "Record is not found"
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
          model_cls = AR::Model.get_model(req.params[:record_type])
          record = model_cls.where({
            :soa_record_id => req.params[:soa_record_id],
            :id => req.params[:id],
          }).first

          unless record
            raise WEBrick::HTTPStatus::NotFound, "Record is not found"
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
