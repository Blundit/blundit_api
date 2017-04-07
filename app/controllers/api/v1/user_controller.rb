
module Api::V1
    class UserController < ApiController
        before_action :authenticate_current_user

        def get_bookmarks
            @bookmarks = []

            Bookmark.where({ user_id: current_user.id }).each do |b|
                if b.type?
                    @new = {
                        type: b.type?,
                        id: b.id,
                        alias: b.object.alias,
                        new: b.has_update,
                        title: b.type? == "expert" ? b.object.name : b.object.title,
                        notify: b.notify
                    }

                    @bookmarks << @new
                end
            end
        end

        def do_remove_bookmark
            render json: { thing: "yep" }
        end


        def get_votes
            @prediction_votes = PredictionVote.joins(:vote).where("votes.user_id = #{current_user.id}")
            @claim_votes = ClaimVote.joins(:vote).where("votes.user_id = #{current_user.id}")
        end

        
        def update_user
            if current_user.nil?
                render json: { error: "Must be logged in." }, status: 422
                return
            end

            u = User.find(current_user.id)
            if u.update(user_params)
                u.reload
                render json: { status: "User updated", user: u }
            else
                render json: { status: "Error updating user" }, status: 422
            end
        end


        def user_params
            params.permit(
                :email,
                :first_name,
                :last_name,
                :notification_frequency,
                :avatar
            )
        end
    end
end