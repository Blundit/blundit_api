
module Api::V1
    class UserController < ApiController
        before_action :authenticate_user!

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