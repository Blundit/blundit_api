module Api::V1
  class UsersController < ApiController

    def index
      # GET /CONTROLLER
      @users = User.page(current_page)
    end

    def show
      # GET /CONTROLLER/:id
      @user = User.find(params[:id])
    end
  end
end