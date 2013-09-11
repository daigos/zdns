module ZDNS
  module Manager
    class ApiRecordServlet < AbstractApiServlet
      def index(req, res)
        ret = nil
        begin
          model_cls = AR::Model.get_model(req.params[:record_type])
          ret = model_cls.where(:soa_record_id => req.params[:soa_record_id]).load
        rescue => e
          res.status = 500
          ret = e
        end
        _output req, res, ret
      end

      def create(req, res)
        ret = nil
        begin
          # check zone
          unless AR::Model::SoaRecord.where(:id => req.params[:soa_record_id]).first
            raise "Zone is not defined"
          end

          # create record
          model_cls = AR::Model.get_model(req.params[:record_type])
          attrs = _permit_query(req, [:soa_record_id, :name, :ttl]+model_cls::RDATA_FIELDS)
          ret = model_cls.create!(attrs)
        rescue => e
          res.status = 500
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
          res.status = 500
          ret = e
        end
        _output req, res, ret
      end

      def update(req, res)
        attrs = _permit_query(req, [:name, :ttl]+AR::Model::SoaRecord::RDATA_FIELDS)
        record = AR::Model::SoaRecord.where(:id => req.params[:id]).first
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
        ret = nil
        begin
          model_cls = AR::Model.get_model(req.params[:record_type])
          record = model_cls.where({
            :soa_record_id => req.params[:soa_record_id],
            :id => req.params[:id],
          }).first

          if record
            record.destroy!
            ret = record
          else
            raise "Record is not defined"
          end
        rescue => e
          res.status = 500
          ret = e
        end
        _output req, res, ret
      end
    end
  end
end
