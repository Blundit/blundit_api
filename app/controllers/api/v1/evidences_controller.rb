module Api::V1
    class EvidencesController < ApiController

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
                render json: { status: 'success' }
            else
                render json: { error: 'Unable to add evidence' }, status: 422
            end
        end
    end
end
