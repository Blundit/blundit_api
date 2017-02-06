module Api::V1
  class ExpertsController < ApiController

    def index
      # GET /CONTROLLER
      @experts = Expert.all
    end

    def show
      # GET /CONTROLLER/:id
      @id = Expert.find(params[:id])
    end

    def new
      # GET /pundits/new

    end

    def create
      # POST /pundits
      @expert = Expert.new(expert_params)

      if @expert.save
        render json: { result: "success" }
      else
        render json: { result: "error" }
      end



    end

    def edit
      # PUT /pundits/:id

    end

    def destroy
      # DELETE /pundits/:id
    end

    def expert_params
        params.permit(
          :name
        )
    end
  end
end