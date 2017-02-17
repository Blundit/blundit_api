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


    def add_category

    end

    
    def remove_category


    def add_publication
      # /experts/:expert_id/add_publication
      # TODO: Page scrape here to take url and determine title and description, figure out if it's amazon, youtube or whatever?
      # How complicated should this be?
      @expert = Expert.find_by_id(params[:expert_id])

      if @expert.nil?
        render json: { error: 'Expert Not Found' }, status: 422
        return
      end
      
      @publication = Publication.create(publication_params)

      if @expert.publications << @publication
        add_contribution(@publication, :created_publication)
        add_contribution(@expert, :added_publication)
        render json: { status: 'success' }
      else
        render json: { error: 'Unable to Add Publication to Expert' }, status: 422
      end
    end


    def add_comment
      # /experts/:expert_id/add_comment
      @expert = Expert.find_by_id(params[:expert_id])

      if @expert.nil?
        render json: { error: 'Expert Not Found' }, status: 422
        return
      end

      @comment = Comment.create(comment_params)

      if @experts.comments << @comment
        current_user.comments << @comment
        add_contribution(@expert, :added_comment)
      end
    end


    def add_claim
      @expert = Expert.find_by_id(params[:expert_id])
      @claim = Claim.find_by_id(params[:claim_id])

      if @expert.nil?
        render json: { error: "Expert Not Found" }, status: 422
        return
      end

      if @claim.nil?
        render json: { error: "Claim Not Found" }, status: 422
        return
      end
      
      if params.has_key?(:claim_id)
          @claim.experts << @expert
          @expert.claims << @claim
          @expert.calc_accuracy

          add_contribution(@expert, :added_claim)
      else
          render json: { error: "Claim ID Not Found" }, status: 422
      end
    end


    def add_prediction
      @expert = Expert.find_by_id(params[:expert_id])
      @prediction = Prediction.find_by_id(params[:prediction_id])

      if @expert.nil?
        render json: { error: "Expert not found" }, status: 422
        return
      end

      if @prediction.nil?
        render json: { error: "Prediction not found" }, status: 422
        return
      end
      
      if params.has_key?(:prediction_id)
        @prediction.experts << @expert
        @expert.predictions << @prediction
        @expert.calc_accuracy
        add_contribution(@expert, :added_claim)
      else
        render json: { error: "Expert ID Not Found" }, status: 422
      end
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
          :avatar_file_name,
          :tag_list
        )
    end


    def publication_params
      params.permit(
        :title,
        :url,
        :description,
        :expert_id
      )
    end


    def comment_params
      params.permit(
        :title,
        :content
      )
    end
  end
end