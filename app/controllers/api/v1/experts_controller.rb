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

    def sidekiq
      # ClaimWorker.perform_async("Async")
      # ClaimWorker.perform_in(30.seconds, "30 Seconds")
      # ClaimWorker.perform_at(1.minute.from_now, "1 minute")
      # ClaimWorker.perform_at("2017-02-20 8:59".to_time, "8:59")
      ClaimWorker.perform_async(1)
    end


    def destroy
      # DELETE /pundits/:id
      if !has_permission_to_destroy
        render json: { result: "You don't have permission to destroy." }, status: 422
        return
      end

      if params.has_key?(:id)
        if @expert.destroy
          add_contribution(@expert, :destroyed_expert)
          render json: { result: "success" }
        else
          render json: { result: "error" }
        end
      else
        render json: { result: "ID Not Found" }, status: 422
      end
    end


    def search
      @expert = Expert.do_search(params[:term])
    end


    def add_category
      @expert = Expert.find_by_id(params[:expert_id])

      if @expert.nil?
        render json: { error: "Expert Not Found" }, status: 422
        return
      end

      if @category.nil?
        render json: { error: "Category Not Found" }, status: 422
        return
      end

      @expert.add_category_if_necessary(params[:category_id], 1)
      if @expert.save
        add_contribution(@expert, :added_category)
        render json: { status: "success" }
      else
        render json: { error: "Unable to Add Category" }, status: 422
      end
    end


    def add_tag
      @expert = Expert.find_by_id(params[:expert_id])
      if @expert.nil?
        render json: { error: "Expert Not Found" }, status: 422
        return
      end

      if !params.has_key?(:tag)
        render json: { error: "Tag Required" }, status: 422
        return
      end

      @expert.tag_list.add(params[:tag])

      if @expert.save
        add_contribution(@expert, :added_tag)
        render json: { status: "Success" }
      else
        render json: { status: "Error" }, status: 422
      end
    end


    def remove_tag
      @expert = Expert.find_by_id(params[:expert_id])
      if @expert.nil?
        render json: { error: "Expert Not Found" }, status: 422
        return
      end

      if !params.has_key?(:tag)
        render json: { error: "Tag Required" }, status: 422
        return
      end

      @expert.tag_list.remove(params[:tag])
      
      if @expert.save
        add_contribution(@expert, :removed_tag)
        render json: { status: "Success" }
      else
        render json: { status: "Error" }, status: 422
      end
    end

    
    def remove_category
      if !params.has_key?(:category_id)
        render json: { error: "Category ID Not Found" }, status: 422
        return
      end

      if !params.has_key?(:expert_id)
        render json: { error: "Expert ID Not Found" }, status: 422
        return
      end

      @expert = Expert.find_by_id(params[:expert_id])
      @category = Category.find_by_id(params[:category_id])

      if @category.nil?
        render json: { error: "Category Not Found" }, status: 422
        return
      end

      if @expert.nil?
        render json: { error: "Expert Not Found" }, status: 422
        return
      end

      if @expert.expert_categories.where("category_id = ?", params[:category_id]).first.destroy
        add_contribution(@expert, :removed_category)
        render json: { status: "Success" }
      else
        render json: { status: "Error" }
      end
    end


    def add_publication
      # /experts/:expert_id/add_publication
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


    # remove comment is in application helper


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


    def remove_claim
      if !params.has_key?(:expert_id) or !params.has_key?(:claim_id)
        render json: { error: "Expert ID and Claim ID required" }, status: 422
        return
      end

      @expert = Expert.find_by_id(params[:expert_id])
      @claim = Claim.find_by_id(params[:claim_id])

      @removed = true

      @expert_claim = @expert.expert_claims.find_by_claim_id(params[:claim_id])
      if @expert_claim != nil

        if @expert_claim.destroy
          
        else
          @removed = false
        end
      end

      @claim_expert = @claim.claim_experts.find_by_expert_id(params[:expert_id])
      if @claim_expert != nil
        if @claim_expert.destroy
        
        else
          @removed = false
        end
      end

      if @removed == true
        add_contribution(@expert, :removed_claim)
        render json: { status: "Success" }
      else
        render json: { status: "Error" }
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


    def remove_prediction
      if !params.has_key?(:expert_id) or !params.has_key?(:prediction_id)
        render json: { error: "Expert ID and Prediction ID required" }, status: 422
        return
      end

      @expert = Expert.find_by_id(params[:expert_id])
      @prediction = Prediction.find_by_id(params[:prediction_id])

      @removed = true

      @expert_prediction = @expert.expert_predictions.find_by_claim_id(params[:prediction_id])
      if @expert_prediction != nil
        if @expert_prediction.destroy
          
        else
          @removed = false
        end
      end

      @prediction_expert = @prediction.prediction_experts.find_by_expert_id(params[:expert_id])
      if @prediction_expert != nil
        if @prediction_expert.destroy
        
        else
          @removed = false
        end
      end

      if @removed == true
        add_contribution(@expert, :removed_prediction)
        render json: { status: "Success" }
      else
        render json: { status: "Error" }
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