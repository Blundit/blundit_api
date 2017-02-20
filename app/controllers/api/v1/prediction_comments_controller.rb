module Api::V1
  class PredictionCommentsController < ApiController

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
      if !@hasPermissionToDestroy()
        return json: { result: "You don't have permission to destroy." }, status: 422
      end
    end
  end
end