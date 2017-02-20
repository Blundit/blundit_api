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

        if params.has_key?(:expert_id)
          @expert = Expert.find(params[:expert_id])
          @expert.claims << @claim
          @claim.experts << @expert
        end

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

      if !@hasPermissionToDestroy()
        return json: { result: "You don't have permission to destroy." }, status: 422
      end

      if params.has_key?[:id]
    
        if @claim.destroy
          add_contribution(@claim, :destroyed_claim)
          render json: { result: "success" }
        else
          render json: { result: "error" }
        end
      else
        render json: { result: "ID Not Found" }, status: 422
      end
    end


    def search
      @claim = Claim.search(params[:term])
    end


    def add_comment
      # /claims/:claim_id/add_comment
      @claim = Claim.find_by_id(params[:claim_id])

      if @claim.nil?
        render json: { error: 'Claim Not Found' }, status: 422
        return
      end

      @comment = Comment.create(comment_params)

      if @claim.comments << @comment
        current_user.comments << @comment
        add_contribution(@claim, :added_comment)
      end
    end


    def add_category
      @claim = Claim.find_by_id(params[:claim_id])
      @category = Category.find_by_id(params[:category_id])

      if @claim.nil?
        render json: { error: "Claim Not Found" }, status: 422
        return
      end

      if @category.nil?
        render json: { error: "Category Not Found" }, status: 422
        return
      end

      if @claim.categories << @category
        @claim.update_expert_categories(params[:category_id], true)
        add_contribution(@claim, :added_category)
        render json: { status: "success" }
      else
        render json: { error: "Unable to Add Category" }, status: 422
      end
    end


    def remove_category
      @claim = Claim.find_by_id(params[:claim_id])
      @category = Category.find_by_id(params[:category_id])

      if @claim.nil?
        render json: { error: "Claim Not Found" }, status: 422
        return
      end

      if @category.nil?
        render json: { error: "Category Not Found" }, status: 422
        return
      end

      if @claim.categories.find(params[:category_id]).destroy
        @claim.update_expert_categories(params[:category_id], false)
        add_contribution(@claim, :removed_category)
        render json: { status: "success" }
      else
        render json: { error: "Unable to Remove Category" }, status: 422
      end
    end


    def add_tag
      @claim = Claim.find_by_id(params[:claim_id])
      if @claim.nil?
        render json: { error: "Claim Not Found" }, status: 422
        return
      end

      if !params.has_key?(:tag)
        render json: { error: "Tag Required" }, status: 422
      end

      @claim.tag_list.add(params[:tag])

      if @claim.save
        add_contribution(@claim, :added_tag)
        render json: { status: "Success" }
      else
        render json: { status: "Error" }, status: 422
      end
    end


    def remove_tag
      @claim = Claim.find_by_id(params[:claim_id])
      if @claim.nil?
        render json: { error: "Claim Not Found" }, status: 422
        return
      end

      if !params.has_key?(:tag)
        render json: { error: "Tag Required" }, status: 422
      end

      @claim.tag_list.remove(params[:tag])
      
      if @claim.save
        add_contribution(@claim, :removed_tag)
        render json: { status: "Success" }
      else
        render json: { status: "Error" }, status: 422
      end
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
        :tag_list,
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