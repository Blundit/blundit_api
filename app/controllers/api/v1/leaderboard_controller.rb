module Api::V1
    class LeaderboardController < ApiController
        def all
            @all = []
        end


        def claims
            if params[:status].nil?
                @status = 0
            else
                @status = params[:status]
            end

            @claims = Claim.order('vote_value DESC').where(status: @status)
        end


        def predictions
            if params[:status].nil?
                @status = 0
            else
                @status = params[:status]
            end

            @predictions = Prediction.order('vote_value DESC').where(status: @status)
        end


        def experts
            @experts = Expert.order('accuracy DESC')
        end
    end
end