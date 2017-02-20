module Api::V1
  class ClaimCommentsController < ApiController

    def index
      # GET /CONTROLLER
    end

    def show
      # GET /CONTROLLER/:id
      @id = "SHOW"
    end

    def new
      # GET /pundits/new

    end

    def create
      # POST /pundits

    end

    def edit
      # PUT /pundits/:id

    end

    def destroy
      # DELETE /pundits/:id
      if !has_permission_to_destroy
        render json: { result: "You don't have permission to destroy." }, status: 422
        return
      end
    end
  end
end