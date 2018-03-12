
module Api::V1
    class UserController < ApiController
        before_action :authenticate_current_user, except: [:authenticate, :get_avatar]
        
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


        def get_avatar
            if current_user.nil? and params[:user_id]
                current_user = User.find(params[:user_id])
            end

            if current_user.nil? 
                render json: { error: "Must be logged in." }, status: 422
            end

            render json: { avatar: current_user.avatar.url(:medium) }
        end

        
        def update_user
            if current_user.nil?
                render json: { error: "Must be logged in." }, status: 422
                return
            end

            user = User.find(current_user.id)
            if user.update(user_params)
                user.reload
                render json: { user: user, avatar: user.avatar.url(:medium) }
            else
                render json: { status: "Error updating user" }, status: 422
            end
        end


        def authenticate
            if !params.has_key?(:uid) or !params.has_key?(:client)
                render json: { error: "Data missing." }, status: 401
                return
            end
            current_user = User.find_by({ uid: params[:uid] })
            if current_user.nil?
                render json: { error: "User not found" }, status: 401
                return
            end

            if current_user && current_user.tokens.has_key?(params[:client])
                token = current_user.tokens[params[:client]]
                expiration_datetime = DateTime.strptime(token["expiry"].to_s, "%s")

                if expiration_datetime > DateTime.now
                    @current_user = current_user
                end
            end

            if @current_user
                render json: { status: "You're currently logged in.", data: params }
            else
                render json: { error: "Authentication failed." }, status: 401
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