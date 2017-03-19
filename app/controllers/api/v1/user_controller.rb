
module Api::V1
    class UserController < ApiController
        before_action :authenticate_current_user

        def get_bookmarks
            @bookmarks = []

            Bookmark.where({ user_id: current_user.id }).each do |b|
                if b.type?
                    @new = {
                        type: b.type?,
                        id: b.object.id,
                        new: b.has_update,
                        title: b.type? == "expert" ? b.object.name : b.object.title
                    }

                    @bookmarks << @new
                end
            end
        end


        def user_params
            params.permit(
                :email,
                :first_name,
                :last_name,
                :avatar
            )
        end
    end
end