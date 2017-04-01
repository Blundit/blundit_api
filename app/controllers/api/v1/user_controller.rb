
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