module Api::V1
  class ClaimsController < ApiController

    def index
      # GET /CONTROLLER
      @claims = Claim.all
    end

    def show
      # GET /CONTROLLER/:id
      if params[:id] == 'search' && !params[:term].nil?
        return self.search
      end
      
      if params[:id].to_i != 0
        @claim = Claim.find_by_id(params[:id])
      else
        @claim = Claim.where(alias: params[:id]).first

        if @claim.nil?
          render json: { errors: "Claim Not Found" }, status: 422
        end
      end
    end

    def new
      # GET /pundits/new
      @claim = Claim.new
    end

    def create
      # POST /pundits
      @claim = Claim.new(claim_params)

      if @claim.save
        add_contribution(@claim, :created_claim)
        render json: { result: "success" }
      else
        render json: { result: "error" }
      end
    end

    def edit
      # PUT /pundits/:id
      if @claim.update(claim_params)
        add_contribution(@claim, :edited_claim)
        render json: { result: "success" }
      else
        render json: { result: "error" }
      end
    end

    def destroy
      # DELETE /pundits/:id
      if params[:id]
        if @claim.destroy
          add_contribution(@claim, :destroyed_claim)
          render json: { result: "success" }
        else
          render json: { result: "error" }
        end
      else
        render json: { result: "error" }
      end
    end

    def search
      @claim = Claim.search(params[:term])
    end

    private

    def set_claim
      @claim = Claim.find(params[:id])
    end

    def claim_params
      params.permit(
        :title,
        :description,
        :url,
      )
    end
  end
end