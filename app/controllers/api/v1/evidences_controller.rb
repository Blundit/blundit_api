module Api::V1
    class EvidencesController < ApiController
        before_action :authenticate_current_user
        
        def add_evidence
            return if params[:url].nil? or (params[:prediction_id].nil? and params[:claim_id].nil?)

            @page = MetaInspector.new(params[:url], :allow_non_html_content => true)
            evidence_params = {
                title: @page.best_title,
                domain: @page.host,
                description: @page.description,
                image: @page.images.best,
                url: params[:url],
                url_content: @page.hash,
            }

            if !params[:prediction_id].nil?
                @added = Prediction.find(params[:prediction_id]).evidences << @evidence = Evidence.create(evidence_params)
            else
                @added = Claim.find(params[:claim_id]).evidences << @evidence = Evidence.create(evidence_params)
            end

            if @added
                add_contribution(@evidence, :added_evidence)
                add_or_update_publication(@page.host)

                render json: { status: 'success' }
            else
                render json: { error: 'Unable to add evidence' }, status: 422
            end
        end
        

        def remove_evidence
            if !has_permission_to_remove
                render json: { error: "You don't have permission to remove this" }, status: 422
                return 
            end

            if !params.has_key?(:id)
                render json: { error: "ID Not Found" }, status: 422
                return
            end

            @evidence = Evidence.find_by_id(params[:id])

            if @evidence.nil?
                render json: { error: "Evidence Not Found" }, status: 422
                return
            end

            if @evidence.destroy
                add_contribution(@evidence, :destroyed_evidence)
                render json: { status: "Success" }
            else
                render json: { status: "Error" }
            end
        end
    end
end
