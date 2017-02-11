
module Api::V1
    class PredictionsController < ApiController
        def add_bookmark(type, id)
            params = { user_id: current_user.id }
            params["#{type}_id"] = id
            
            if current_user.bookmarks << Bookmark.create(params)
                render json: { result: "Success" }
            else
                render json: { error: "Unable to add bookmark" }, status: 422
            end
        end


        def remove_bookmark(id)
            if Bookmark.find(id).destroy
                render json: { result: "Success" }
            else
                render json: { error: "Unable to remove bookmark" }, status: 422
            end


        end
    end
end