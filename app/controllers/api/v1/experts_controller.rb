module Api::V1
  class ExpertsController < ApiController
    before_action :set_expert, only: [:edit, :update, :destroy]

    def index
      # GET /CONTROLLER
      @experts = Expert.all
    end


    def show
      # GET /CONTROLLER/:id
      if params[:id] == 'search' && !params[:term].nil?
        return self.search
      end
      
      if params[:id].to_i != 0
        @expert = Expert.find_by_id(params[:id])
      else
        @expert = Expert.where(alias: params[:id]).first

        if @expert.nil?
          render json: { errors: "Expert Not Found" }, status: 422
        end
      end
    end


    def new
      # GET /pundits/new
      @expert = Expert.new
    end


    def create
      # POST /pundits
      @expert = Expert.new(expert_params)

      if @expert.save
        add_contribution(@expert, :created_expert)

        if params.has_key?(:prediction_id)
          @prediction = Prediction.find(params[:prediction_id])
          @prediction.experts << @expert
          @expert.predictions << @prediction
        elsif params.has_key?(:claim_id)
          @claim = Claim.find(params[:claim_id])
          @claim.experts << @expert
          @expert.claims << @claim
        end

        render json: { result: "success" }
      else
        render json: { result: "error" }
      end
    end


    def edit
      # PUT /pundits/:id
      if @expert.update(expert_params)
        add_contribution(@expert, :edited_expert)
        render json: { result: "success" }
      else
        render json: { result: "error" }
      end

    end


    def destroy
      # DELETE /pundits/:id

      if params[:id]
        if @expert.destroy
          add_contribution(@expert, :destroyed_expert)
          render json: { result: "success" }
        else
          render json: { result: "error" }
        end
      else
        render json: { result: "error" }
      end
    end


    def search
      @expert = Expert.search(params[:term])
    end


    private

    def set_expert
      @expert = Expert.find(params[:id])
    end


    def expert_params
        params.permit(
          :name,
          :description,
          :email,
          :twitter,
          :facebook,
          :instagram,
          :youtube,
          :avatar_file_name
        )
    end
  end
end