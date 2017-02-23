module ApplicationHelper
    def has_permission_to_destroy
        # TODO: Make this actually check user object for an admin property,
        # and check categories
        false
    end


    def has_permission_to_remove
        # TODO: Make this actually check user object for admin property,
        # and check categories
        false
    end


    def remove_comment(id, reason = nil)
      if !params.has_key?(:id)
        render json: { error: "Comment ID Not Found" }, status: 422
        return
      end

      @comment = Comment.find_by_id(params[:id])
      

      if @comment.nil?
        render json: { error: "Comment Not Found" }, status: 422
        return
      end

      @comment.visibility = false
      @comment.reason_for_hiding = reason
      
      if @comment.save
        render json: { status: "Success" }
      else
        render json: { status: "Error" }
      end
    end

    def mark_as_read(object)
      current_user.bookmarks.where("#{object.class.name.downcase}_id = ?", object.id).each do |bookmark|
        bookmark.update({ has_update: false })
      end
    end
end
