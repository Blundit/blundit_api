module Api::V1
  class PredictionsController < ApiController
    before_action :authenticate_current_user, except: [:index, :show, :search, :all, :comments]
    before_action :set_prediction, only: [:edit, :update, :destroy]
    before_filter :set_user, only: [:index, :show, :search, :comments]

    def index
      # GET /CONTROLLER
      @predictions = Prediction.do_search(params[:query], params[:sort]).order('created_at DESC').page(current_page).per(per_page)
      @current_page = current_page
      @per_page = per_page
    end


    def all
      # TODO: Show only active
      @predictions = Prediction.all
    end


    def show
      # TODO: Make this search
      # GET /CONTROLLER/:id
      if params[:id] == 'search' && !params[:term].nil?
        redirect_to search and return
      end

      if params[:id] == 'all'
        redirect_to all and return
      end
      
      if params[:id].to_i != 0
        @prediction = Prediction.find_by_id(params[:id])
      else
        @prediction = Prediction.where(alias: params[:id]).first

        if @prediction.nil?
          render json: { errors: "Prediction Not Found" }, status: 422
        end
      end

      if current_user.nil?
        @user_vote = nil
        @bookmark = nil
      else
        @user_vote = @prediction.votes.where({user_id: current_user.id}).first
        @bookmark = current_user.bookmarks.find_by_prediction_id(@prediction.id)
      end

      mark_as_read(@prediction)
    end


    def set_user
      current_user = get_current_user_2
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

        if params.has_key?(:url)
          add_evidence(@prediction, params[:url])
        end

        if params.has_key?(:category)
          add_category(@prediction, params[:category])
        end

        add_bookmark("prediction", @prediction.id)
        render json: { result: "success", prediction: @prediction }
      else
        render json: { result: "error" }
      end
    end


    def add_evidence(prediction = nil, url = nil)

      if url.nil? and params.has_key?(:url)
        url = params[:url]
      end

      if prediction.nil? and params.has_key?(:prediction_id)
        prediction = Prediction.find(params[:prediction_id])
      end
      
      return if url.nil? or prediction.nil?
      return if url.index("://").nil?

      @page = MetaInspector.new(url, :allow_non_html_content => true)
      evidence_params = {
        title: @page.best_title,
        domain: @page.host,
        description: @page.description,
        image: @page.images.best,
        url: params[:url],
        url_content: @page.hash,
      }

      if !prediction.nil?
        @added = prediction.evidences << @evidence = Evidence.create(evidence_params)
      end

      if @added
        add_contribution(@evidence, :added_evidence)
        add_or_update_publication(@page.host)
        add_bookmark("prediction", prediction.id)

        # if prediction.pic_file_name.nil?
        #   prediction.pic = URI.parse(@page.images.best)
        #   prediction.save
        # end

        attrs = {
          prediction_id: prediction.id,
          item_type: "prediction_evidence_added",
          message: "Evidence added to #{prediction.title}"
        }
        NotificationQueue::delay.process(attrs)
      end
    end


    def vote
      if !params.has_key?(:prediction_id) or !params.has_key?(:value)
        render json: { result: "prediction_id and value are both required" }, status: 422
        return
      end

      @prediction = Prediction.find(params[:prediction_id])
      
      if @prediction.nil?
        render json: { result: "Prediction #{params[:prediction_id]}" }, status: 422
        return
      end

      if @prediction.votes << Vote.create({ user_id: current_user.id, vote: params[:value].to_i })
        add_bookmark("prediction", @prediction.id)
        render json: { result: "success" }
      else
        render json: { result: "error" }
      end
    end


    # def edit
    #   # PUT /pundits/:id
    #   if @prediction.update(prediction_params)
    #     add_contribution(@prediction, :edited_prediction)
    #     add_bookmark("prediction", @prediction.id)
    #     render json: { result: "success" }
    #   else
    #     render json: { result: "error" }
    #   end
    # end


    # def destroy
    #   # DELETE /pundits/:id
    #   if !has_permission_to_destroy
    #     render json: { result: "You don't have permission to destroy." }, status: 422
    #     return
    #   end

    #   #TODO: Make this mark as invalid rather than destroy.
    #   if params.has_key?(:id)
    #     if @prediction.destroy
    #       add_contribution(@prediction, :destroyed_prediction)
    #       remove_bookmark(@prediction.id, "prediction")
    #       render json: { result: "success" }
    #     else
    #       render json: { result: "error" }
    #     end
    #   else
    #     render json: { result: "ID Not Found" }, status: 422
    #   end
    # end


    def search
      @predictions = Prediction.do_search(params[:term]).page(current_page).per(per_page)
      @current_page = current_page
      @per_page = per_page
    end


    def comments
      @prediction = Prediction.find_by_id(params[:prediction_id])

      if @prediction.nil?
        render json: { error: 'Prediction Not Found' }, status: 422
        return
      end

      @comments = @prediction.comments.order('created_at DESC').page(current_page).per(per_page)
    end


    def add_comment
      # /predictions/:prediction_id/add_comment
      @prediction = Prediction.find_by_id(params[:prediction_id])

      if @prediction.nil?
        render json: { error: 'Prediction Not Found' }, status: 422
        return
      end

      params[:user_id] = current_user.id

      @comment = Comment.create(comment_params)

      if @prediction.comments << @comment
        current_user.comments << @comment
        add_contribution(@prediction, :added_comment)
        add_bookmark("prediction", @prediction.id)

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

    def update_image
      if !params.has_key?(:prediction_id) or !params.has_key?(:pic)
        render json: { error: "Prediction ID and Avatar required." }, status: 422
        return
      end

      @prediction = Prediction.find_by_id(params[:prediction_id])

      if @prediction.nil?
        render json: { error: "Prediction not found" }, status: 422
        return
      end

      if @prediction.update(image_params)
        add_contribution(@prediction, :updated_image)
        render json: { status: "Success!" }
      else
        render json: { error: "There was an error updating" }, status:422
      end
    end


    def delete_image
      if !params.has_key?(:prediction_id)
        render json: { error: "Prediction ID required." }, status: 422
        return
      end

      @prediction = Prediction.find_by_id(params[:prediction_id])

      if @prediction.nil?
        render json: { error: "Prediction not found" }, status: 422
        return
      end

      if @prediction.delete_image
        add_contribution(@prediction, :deleted_image)
        render json: { status: "Success!" }
      else
        render json: { error: "Error" }, status: 422
      end
    end


    def add_category(prediction, category_id)
      
      if prediction.nil?
        @prediction = Prediction.find_by_id(params[:prediction_id])
      else
        @prediction = prediction
      end
      
      if category_id.nil?
        category_id = params[:category_id]
      end

      @category = Category.find_by_id(category_id)

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

        attrs = {
          prediction_id: @prediction.id,
          item_type: "prediction_category_added",
          message: "Category '#{@category.name}' added to #{@prediction.title}"
        }
        NotificationQueue::delay.process(attrs)

        if params.has_key?(:prediction_id)
          render json: { status: "success" }
        end
      else
        if params.has_key?(:prediction_id)
          render json: { error: "Unable to Add Category" }, status: 422
        end
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

        attrs = {
          prediction_id: @prediction.id,
          item_type: "prediction_category_removed",
          message: "Category '#{@category.name}' removed from #{@prediction.title}"
        }
        NotificationQueue::delay.process(attrs)


        render json: { status: "success" }
      else
        render json: { error: "Unable to Add Category" }, status: 422
      end
    end  


    def add_expert
      @prediction = Prediction.find_by_id(params[:prediction_id])
      @expert = Expert.find_by_id(params[:id])

      if @prediction.nil?
        render json: { error: "Prediction Not Found" }, status: 422
        return
      end

      if @expert.nil?
        render json: { error: "Expert Not Found" }, status: 422
        return
      end

      if @prediction.experts << @expert
        @expert.predictions << @prediction
        add_contribution(@prediction, :added_expert)
        add_bookmark("prediction", @prediction.id)

        attrs = {
          expert_id: @expert.id,
          prediction_id: @prediction.id,
          item_type: "prediction_expert_added",
          message: "#{@expert.name} added to #{@prediction.title}"
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
        
        attrs = {
          expert_id: @expert.id,
          prediction_id: @prediction.id,
          item_type: "prediction_expert_removed",
          message: "#{@expert.title} removed from #{@prediction.title}"
        }
        NotificationQueue::delay.process(attrs)
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
        :pic,
        :prediction_date
      )
    end

    def image_params
      params.permit(:pic)
    end


    def comment_params
      params.permit(
        :title,
        :content,
        :user_id
      )
    end
  end
end