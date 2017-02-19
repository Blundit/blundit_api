module Api::V1
  class PredictionsController < ApiController
    before_action :set_prediction, only: [:edit, :update, :destroy]

    def index
      # GET /CONTROLLER
      @predictions = Prediction.all
    end


    def show
      # GET /CONTROLLER/:id
      if params[:id] == 'search' && !params[:term].nil?
        return self.search
      end
      
      if params[:id].to_i != 0
        @prediction = Prediction.find_by_id(params[:id])
      else
        @prediction = Prediction.where(alias: params[:id]).first

        if @prediction.nil?
          render json: { errors: "Prediction Not Found" }, status: 422
        end
      end
    end


    def new
      # GET /pundits/new
      @prediction = Prediction.new
    end


    def create
      # POST /pundits
      @prediction = Prediction.new(prediction_params)

      if @prediction.save
        add_contribution(@prediction, :created_prediction)
        
        if params.has_key?(:expert_id)
          @expert = Expert.find(params[:expert_id])
          @expert.predictions << @prediction
          @prediction.experts << @expert
        end

        render json: { result: "success" }
      else
        render json: { result: "error" }
      end
    end


    def edit
      # PUT /pundits/:id
      if @prediction.update(prediction_params)
        add_contribution(@prediction, :edited_prediction)
        render json: { result: "success" }
      else
        render json: { result: "error" }
      end
    end


    def destroy
      # DELETE /pundits/:id
      if params[:id]
        if @prediction.destroy
          add_contribution(@prediction, :destroyed_prediction)
          render json: { result: "success" }
        else
          render json: { result: "error" }
        end
      else
        render json: { result: "error" }
      end
    end


    def search
      @prediction = Prediction.search(params[:term])
    end


    def add_comment
      # /predictions/:prediction_id/add_comment
      @prediction = Prediction.find_by_id(params[:prediction_id])

      if @prediction.nil?
        render json: { error: 'Prediction Not Found' }, status: 422
        return
      end

      @comment = Comment.create(comment_params)

      if @prediction.comments << @comment
        current_user.comments << @comment
        add_contribution(@prediction, :added_comment)

      end
    end


    def add_category
      @prediction = Prediction.find_by_id(params[:prediction_id])
      @category = Category.find_by_id(params[:category_id])

      if @prediction.nil?
        render json: { error: "Prediction Not Found" }, status: 422
        return
      end

      if @category.nil?
        render json: { error: "Category Not Found" }, status: 422
        return
      end

      if @prediction.categories << @category
        @prediction.update_expert_categories(params[:category_id])
        add_contribution(@prediction, :added_category)
        render json: { status: "success" }
      else
        render json: { error: "Unable to Add Category" }, status: 422
      end
    end


    private

    def set_prediction
      @prediction = Prediction.find(params[:id])
    end


    def prediction_params
      params.permit(
        :title,
        :description,
        :tag_list
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