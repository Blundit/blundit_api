module Api::V1
    class LeaderboardController < ApiController
        def all
            @all = []
        end

        ## CLAIMS
        def claims
            @status = nil
            @status = params[:status] if params.has_key?(:status)

            @claims = Claim.order('vote_value DESC')
            @claims = @claims.where(status: @status) if !@status.nil?
        end


        def newest_claims
            @status = nil
            @sort = "DESC"

            @status = params[:status] if params.has_key?(:status)
            @sort = params[:sort] if params.has_key?(:sort)
 
            @claims = Claim.order("created_at #{@sort}")
            @claims = @claims.where(status: @status) if !@status.nil?
        end


        def recently_updated_claims
            @status = nil
            @sort = "DESC"

            @status = params[:status] if params.has_key?(:status)
            @sort = params[:sort] if params.has_key?(:sort)

            @claims = Claim.order("updated_at #{@sort}")
            @claims = @claims.where(status: @status) if !@status.nil?
        end


        ## PREDICTIONS
        def predictions
            @sort = "DESC"

            @status = params[:status] if params.has_key?(:status)
            @sort = params[:sort] if params.has_key?(:sort)
            
            @predictions = Prediction.order("vote_value #{@sort}")
            @predictions = @predictions.where(status: @status) if @status.nil?
        end


        def newest_predictions
            @sort = "DESC"

            @status = params[:status] if params.has_key?(:status)
            @sort = params[:sort] if params.has_key?(:sort)

            @predictions = Prediction.order("created_at #{@sort}")
            @predictions = @predictions.where(status: @status) if !@status.nil?
        end


        def recently_updated_predictions
            @sort = "DESC"

            @status = params[:status] if params.has_key?(:status)
            @sort = params[:sort] if params.has_key?(:sort)

            @predictions = Prediction.order("created_at #{@sort}")
            @predictions = @predictions.where(status: @status) if !@status.nil?
        end


        ## EXPERTS
        def experts
            @sort = "DESC"

            @sort = params[:sort] if params.has_key?(:sort)

            @experts = Expert.order("accuracy #{@sort}")
        end


        def newest_experts
            @sort = "DESC"

            @sort = params[:sort] if params.has_key?(:sort)

            @experts = Expert.order("created_at #{@sort}")
        end


        def recently_updated_experts
            @sort = "DESC"

            @status = params[:status] if params.has_key?(:status)
            @sort = params[:sort] if params.has_key?(:sort)

            @experts = Expert.order("updated_at #{@sort}")
            @experts = @experts.where(status: @status) if !@status.nil?
        end
    end
end