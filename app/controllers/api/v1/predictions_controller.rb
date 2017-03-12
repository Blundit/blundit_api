module Api::V1
  class PredictionsController < ApiController
    before_action :authenticate_user!, except: [:index, :show, :search]
    before_action :set_prediction, only: [:edit, :update, :destroy]

    def index
      # GET /CONTROLLER
      @predictions = Prediction.page(current_page).page(current_page).per(per_page)
      @current_page = current_page
      @per_page = per_page
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

      mark_as_read(@prediction)
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

        add_bookmark("prediction", @prediction.id)
        render json: { result: "success" }
      else
        render json: { result: "error" }
      end
    end


    def edit
      # PUT /pundits/:id
      if @prediction.update(prediction_params)
        add_contribution(@prediction, :edited_prediction)
        add_bookmark("prediction", @prediction.id)
        render json: { result: "success" }
      else
        render json: { result: "error" }
      end
    end


    def destroy
      # DELETE /pundits/:id
      if !has_permission_to_destroy
        render json: { result: "You don't have permission to destroy." }, status: 422
        return
      end

      if params.has_key?(:id)
        if @prediction.destroy
          add_contribution(@prediction, :destroyed_prediction)
          remove_bookmark(@prediction.id, "prediction")
          render json: { result: "success" }
        else
          render json: { result: "error" }
        end
      else
        render json: { result: "ID Not Found" }, status: 422
      end
    end


    def search
      @predictions = Prediction.do_search(params[:term]).page(current_page).per(per_page)
      @current_page = current_page
      @per_page = per_page
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
        add_bookmark("prediction", @prediction.id)

        # add to notification queue for user notifications
        attrs = {
          user_id: current_user.id,
          comment_id: @comment.id,
          prediction_id: @prediction.id,
          item_type: "prediction_comment_added",
          message: @comment.content
        }
        NotificationQueue::delay.process(attrs)
        
        render json: { status: "Success" }
      else
        render json: { status: "Error" }
      end
    end


    # remove comment in application helper


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
        @prediction.update_expert_categories(params[:category_id], true)
        add_contribution(@prediction, :added_category)
        add_bookmark("prediction", @prediction.id)

        render json: { status: "success" }
      else
        render json: { error: "Unable to Add Category" }, status: 422
      end
    end


    def remove_category
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

      if @prediction.expert_categories.find_by_category_id(params[:category_id]).destroy
        @prediction.update_expert_categories(params[:category_id], false)
        add_contribution(@prediction, :removed_category)
        add_bookmark("prediction", @prediction.id)

        render json: { status: "success" }
      else
        render json: { error: "Unable to Add Category" }, status: 422
      end
    end  


    def add_expert
      @prediction = Prediction.find_by_id(params[:prediction_id])
      @expert = Expert.find_by_id(params[:expert_id])

      if @prediction.nil?
        render json: { error: "Prediction Not Found" }, status: 422
        return
      end

      if @expert.nil?
        render json: { error: "Expert Not Found" }, status: 422
        return
      end

      if @prediction.experts << @expert
        add_contribution(@prediction, :added_expert)
        add_bookmark("prediction", @prediction.id)

        attrs = {
          user_id: current_user.id,
          expert_id: @expert.id,
          prediction_id: @prediction.id,
          item_type: "expert_added_to_prediction",
        }
        NotificationQueue::delay.process(attrs)


        render json: { status: "success" }
      else
        render json: { error: "Unable to Add Expert" }, status: 422
      end
    end


    def remove_expert
      @prediction = Prediction.find_by_id(params[:prediction_id])
      @expert = Expert.find_by_id(params[:expert_id])

      if @prediction.nil?
        render json: { error: "Prediction Not Found" }, status: 422
        return
      end

      if @expert.nil?
        render json: { error: "Expert Not Found" }, status: 422
        return
      end

      @prediction_expert = @prediction.prediction_experts.find_by_expert_id(params[:expert_id])
      if @prediction_expert != nil
        if @prediction_expert.destroy
        
        else
          @removed = false
        end
      end

      @expert_prediction = @expert.expert_predictions.find_by_claim_id(params[:prediction_id])
      if @expert_prediction != nil
        if @expert_prediction.destroy
        else
          @removed = false
        end
      end

      if @removed == true
        add_contribution(@prediction, :removed_expert)
        add_bookmark("prediction", @prediction.id)
        render json: { status: "Success" }
      else
        render json: { status: "Error" }
      end
    end  


    def add_tag
      @prediction = Prediction.find_by_id(params[:prediction])
      if @prediction.nil?
        render json: { error: "Prediction Not Found" }, status: 422
        return
      end

      if !params.has_key?(:tag)
        render json: { error: "Tag Required" }, status: 422
      end

      @prediction.tag_list.add(params[:tag])

      if @prediction.save
        add_contribution(@claim, :added_tag)
        add_bookmark("prediction", @prediction.id)

        render json: { status: "Success" }
      else
        render json: { status: "Error" }, status: 422
      end
    end


    def remove_tag
      @prediction = Prediction.find_by_id(params[:prediction_id])
      if @prediction.nil?
        render json: { error: "Prediction Not Found" }, status: 422
        return
      end

      if !params.has_key?(:tag)
        render json: { error: "Tag Required" }, status: 422
      end

      @prediction.tag_list.remove(params[:tag])
      
      if @prediction.save
        add_contribution(@prediction, :removed_tag)
        add_bookmark("prediction", @prediction.id)

        render json: { status: "Success" }
      else
        render json: { status: "Error" }, status: 422
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
        :tag_list,
        :prediction_id,
        :user_id,
        :pic
      )
    end


    def comment_params
      params.permit(
        :title,
        :content,
        :user_id,
        :prediction_id
      )
    end
  end
end