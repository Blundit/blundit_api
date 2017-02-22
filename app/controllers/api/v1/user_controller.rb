
module Api::V1
    class UserController < ApiController
        before_action :authenticate_user!



        def add_bookmark
            if params[:type].nil? or params[:id].nil?
                render json: { error: "Missing Data: type and id expected." }, status: 422
                return
            end

            # TODO: remove
            current_user = User.first

            bookmark_params = { "user_id": current_user.id }
            bookmark_params["#{params[:type]}_id".to_sym] = params[:id]

            
            if current_user.bookmarks << Bookmark.create(bookmark_params)
                render json: { result: "Success" }
            else
                render json: { error: "Unable to add bookmark" }, status: 422
            end
        end


        def remove_bookmark
            if params[:id].nil?
                render json: { error: "Missing Data: id expected." }, status: 422
                return
            end

            @bookmark = Bookmark.find(params[:id])

            #TODO: remove
            current_user = User.first

            if @bookmark.user_id != current_user.id
                render json: { error: "Can't remove bookmark belonging to other user." }, status: 422
            end

            if Bookmark.find(params[:id]).destroy
                attrs = {}
                attrs["user_id"] = @bookmmark.user_id
                attrs["#{@bookmark.type?}_id"] = @bookmark.object.id 

                NotificationQueue::delay.prune_unnecessary_queue_items(attrs)
                render json: { result: "Success" }
            else
                render json: { error: "Unable to remove bookmark" }, status: 422
            end
        end
    end
end