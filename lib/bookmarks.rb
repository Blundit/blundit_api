module Bookmarks
    def add_bookmark(type = nil, id = nil)
        if params.has_key?(:type)
            @type = params[:type]
        elsif !type.nil?
            @type = type
        end

        if params.has_key?(:id)
            @id = params[:id]
        elsif !id.nil?
            @id = params[:id]
        end

        if type.nil? or id.nil?
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


    def remove_bookmark(id = nil, find_type = nil)
        if params.has_key?(:id)
            @id = params[:id]
        elsif !id.nil?
            @id = params[:id]
        end

        if id.nil?
            render json: { error: "Missing Data: id expected." }, status: 422
            return
        end

        #TODO: remove
        current_user = User.first
    
        if !find_type.nil?
            id = Bookmark.where("#{find_type}_id = #{id} and user_id = #{current_user.id}").first.id

        @bookmark = Bookmark.find(id)

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
    

    def update_bookmark
        if params.has_key?(:id)
            @id = params[:id]
        elsif !id.nil?
            @id = params[:id]
        end

        if id.nil?
            render json: { error: "Missing Data: id expected." }, status: 422
            return
        end

        @bookmark = Bookmark.find(params[:id])

        #TODO: remove
        current_user = User.first

        if @bookmark.user_id != current_user.id
            render json: { error: "Can't remove bookmark belonging to other user." }, status: 422
        end

        @bookmark.notify = params[:notify]

        if @bookmark.save
            render json: { result: "Success" }
        else
            render json: { error: "Unable to remove Bookmark" }, status: 422
        end
    end
end