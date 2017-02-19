module Api::V1
    class LeaderboardController < ApiController
        def all
            @all = []
        end

        ## CLAIMS
        def claims
            @sort = "DESC"

            @status = params[:status] if params.has_key?(:status)
            @sort = params[:sort] if params.has_key?(:sort)

            @claims = Claim.order("vote_value #{@sort}")
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


        def experts_by_category
            @type = "overall"

            return false if !params.has_key?(:id)

            @type = params[:type] if params.has_key?(:type)
            @sort = params[:sort] if params.has_key?(:sort)

            @experts = ExpertCategoryAccuracy.order("#{@type}_accuracy #{@sort}").where("category_id = #{params[:id]}")
        end
    end
end