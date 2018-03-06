module Api::V1
    class SearchController < ApiController
        def index
            if !params.has_key?(:query)
                render json: { error: "Search Query Required" }, status: 422
                return
            end

            # :sort
            # 0 - Newest
            # 1 - Oldest
            # 2 - Most Recently Updated
            # 3 - Least Recently Updated

            @claims = Claim.do_search(params[:query], params[:sort], nil)
            @experts = Expert.do_search(params[:query], params[:sort])
            @predictions = Prediction.do_search(params[:query], params[:sort], nil)


            # record search history
            @search = Search.new
            @search.query = params[:query]
            @search.user = current_user if !current_user.nil?
            @search.save
        end


        def most_used_tags
            @tags = ActsAsTaggableOn::Tag.most_used
        end

    end
end