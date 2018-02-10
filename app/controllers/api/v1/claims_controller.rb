module Api::V1
  class ClaimsController < ApiController
    before_action :authenticate_current_user, except: [:index, :show, :search, :all, :comments]
    before_action :set_claim, only: [:edit, :update, :destroy]
    before_filter :set_user, only: [:index, :show, :search, :comments]


    def index
      # GET /CONTROLLER
      @claims = Claim.do_search(params[:query], params[:sort]).includes(:experts).includes(claim_categories: :category).includes(:categories).order('created_at DESC').page(current_page).per(per_page)

      @current_page = current_page
      @per_page = per_page
    end


    def all
      @claims = Claim.all
    end

    
    def set_user
      current_user = get_current_user_2
    end


    def show
      # GET /CONTROLLER/:id
      if params[:id] == 'search' && !params[:term].nil?
        redirect_to search and return
      end

      if params[:id] == 'all'
        redirect_to all and return
      end

      if params[:id].to_i != 0
        @claim = Claim.includes(claim_experts: :expert).find_by_id(params[:id])
      else
        @claim = Claim.where(alias: params[:id]).includes(claim_experts: :expert).first

        if @claim.nil?
          render json: { errors: "Claim Not Found" }, status: 422
        end
      end

      if current_user.nil?
        @user_vote = nil
        @bookmark = nil
      else
        @user_vote = @claim.votes.where({user_id: current_user.id}).first
        @bookmark = current_user.bookmarks.find_by_claim_id(@claim.id)
      end

      @user_vote = get_current_user_2


      mark_as_read(@claim)
    end


    def vote
      if !params.has_key?(:claim_id) or !params.has_key?(:value)
        render json: { result: "claim_id and value are both required" }, status: 422
        return
      end

      @claim = Claim.find(params[:claim_id])
      
      if @claim.nil?
        render json: { result: "Claim #{params[:claim_id]}" }, status: 422
        return
      end

      if @claim.votes << Vote.create({ user_id: current_user.id, vote: params[:value].to_i })
        add_bookmark("claim", @claim.id)
        render json: { result: "success" }
      else
        render json: { result: "error" }
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

        if params.has_key?(:url)
          add_evidence(@claim, params[:url])
        end

        if params.has_key?(:category)
          add_category(@claim, params[:category])
        end

        add_bookmark("claim", @claim.id)
        render json: { result: "success", claim: @claim }
      else
        render json: { result: "error" }
      end
    end


    def add_evidence(claim = nil, url = nil)
      if url.nil? and params.has_key?(:url)
        url = params[:url]
      end

      if claim.nil? and params.has_key?(:claim_id)
        claim = Claim.find(params[:claim_id])
      end

      return if url.nil? or claim.nil?
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

      if !claim.nil?
        @added = claim.evidences << @evidence = Evidence.create(evidence_params)
      end

      if @added
        add_contribution(@evidence, :added_evidence)
        add_or_update_publication(@page.host)
        add_bookmark("claim", claim.id)

        # if claim.pic_file_name.nil? and URI
        #   claim.pic = URI.parse(@page.images.best)
        #   claim.save
        # end

        attrs = {
          user_id: current_user.id,
          claim_id: claim.id,
          item_type: "claim_evidence_added",
          message: "Evidence added to #{claim.title}"
        }
        NotificationQueue::delay.process(attrs)
      end
    end


    def search
      @claim = Claim.do_search(params[:term]).page(current_page).per(per_page)
      @current_page = current_page
      @per_page = per_page
    end


    def comments
      @claim = Claim.find_by_id(params[:claim_id])

      if @claim.nil?
        render json: { error: 'Claim Not Found' }, status: 422
        return
      end

      @comments = @claim.comments.order('created_at DESC').page(current_page).per(per_page)
    end


    def add_comment
      # /claims/:claim_id/add_comment
      @claim = Claim.find_by_id(params[:claim_id])

      if @claim.nil?
        render json: { error: 'Claim Not Found' }, status: 422
        return
      end

      params[:user_id] = current_user.id

      @comment = Comment.create(comment_params)   
      # @comment.update({user_id: current_user.id})

      if @claim.comments << @comment
        current_user.comments << @comment
        add_contribution(@claim, :added_comment)

        # add to notification queue for user notifications
        attrs = {
          user_id: current_user.id,
          comment_id: @comment.id,
          claim_id: @claim.id,
          item_type: "claim_comment_added",
          message: @comment.content
        }
        NotificationQueue::delay.process(attrs)

        add_bookmark("claim", @claim.id)

        render json: { status: "Success" }
      else
        render json: { status: "Error" }
      end
    
    end

    # remove comment method defined in application helper.

    def update_image
      if !params.has_key?(:claim_id) or !params.has_key?(:pic)
        render json: { error: "Expert ID and Pic required." }, status: 422
        return
      end

      @claim = Claim.find_by_id(params[:claim_id])

      if @claim.nil?
        render json: { error: "Claim not found" }, status: 422
        return
      end

      if @claim.update(image_params)
        add_contribution(@claim, :updated_image)
        render json: { status: "Success!" }
      else
        render json: { error: "There was an error updating" }, status:422
      end
    end


    def delete_image
      if !params.has_key?(:claim_id)
        render json: { error: "Claim ID required." }, status: 422
        return
      end

      @claim = Claim.find_by_id(params[:claim_id])

      if @claim.nil?
        render json: { error: "Claim not found" }, status: 422
        return
      end

      if @claim.delete_image
        add_contribution(@claim, :deleted_image)
        render json: { status: "Success!" }
      else
        render json: { error: "Error" }, status: 422
      end
    end


    def add_category(claim, category_id)

      if claim.nil?
        @claim = Claim.find_by_id(params[:claim_id])
      else
        @claim = claim
      end
      
      if category_id.nil?
        category_id = params[:category_id]
      end

      @category = Category.find_by_id(category_id)

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
        add_bookmark("claim", @claim.id)

        attrs = {
          claim_id: @claim.id,
          user_id: current_user.id,
          item_type: "claim_category_added",
          message: "Category '#{@category.name}' added to #{@claim.title}"
        }
        NotificationQueue::delay.process(attrs)

        if params.has_key?(:claim_id)
          render json: { status: "success" }
        end
      else
        if params.has_key?(:claim_id)
          render json: { error: "Unable to Add Category" }, status: 422
        end
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
        add_bookmark("claim", @claim.id)

        attrs = {
          claim_id: @claim.id,
          user_id: current_user.id,
          item_type: "claim_category_removed",
          message: "Category '#{@category.name}' removed from #{@claim.title}"
        }
        NotificationQueue::delay.process(attrs)
        render json: { status: "success" }
      else
        render json: { error: "Unable to Remove Category" }, status: 422
      end
    end


    def add_expert
      @claim = Claim.find_by_id(params[:claim_id])
      @expert = Expert.find_by_id(params[:id])

      if @claim.nil?
        render json: { error: "Claim Not Found" }, status: 422
        return
      end

      if @expert.nil?
        render json: { error: "Expert Not Found" }, status: 422
        return
      end

      if @claim.experts.where({id: params[:id]}).count > 0
        render json: { error: "Expert already has this claim." }, status: 422
        return
      end
      
      if @claim.experts << @expert
        @expert.claims << @claim
        add_contribution(@claim, :added_expert)
        add_bookmark("claim", @claim.id)

        attrs = {
          user_id: current_user.id,
          expert_id: @expert.id,
          claim_id: @claim.id,
          item_type: "claim_expert_added",
          message: "#{@expert.name} added to Claim '#{@claim.title}'"
        }

        NotificationQueue::delay.process(attrs)

        render json: { status: "success" }
      else
        render json: { error: "Unable to Add Expert" }, status: 422
      end

    end

    def remove_expert
      @claim = Claim.find_by_id(params[:claim_id])
      @expert = Expert.find_by_id(params[:expert_id])

      if @claim.nil?
        render json: { error: "Claim Not Found" }, status: 422
        return
      end

      if @expert.nil?
        render json: { error: "Expert Not Found" }, status: 422
        return
      end

      @claim_expert = @prediction.claim_experts.find_by_expert_id(params[:expert_id])
      if @claim_expert != nil
        if @claim_expert.destroy
        
        else
          @removed = false
        end
      end

      @expert_claim = @expert.expert_claims.find_by_claim_id(params[:claim_id])
      if @expert_claim != nil
        if @expert_claim.destroy
        else
          @removed = false
        end
      end

      if @removed == true
        add_contribution(@claim, :removed_expert)
        add_bookmark("claim", @claim.id)
        attrs = {
          claim_id: @claim.id,
          user_id: current_user.id,
          item_type: "claim_expert_removed",
          message: "#{@expert.name} removed from Claim '#{@claim.title}'"
        }
        NotificationQueue::delay.process(attrs)
        render json: { status: "Success" }
      else
        render json: { status: "Error" }
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
        return
      end

      @claim.tag_list.add(params[:tag])

      if @claim.save
        add_contribution(@claim, :added_tag)
        add_bookmark("claim", @claim.id)
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
        return
      end

      @claim.tag_list.remove(params[:tag])
      
      if @claim.save
        add_contribution(@claim, :removed_tag)
        add_bookmark("claim", @claim.id)
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
        :claim_id,
        :pic
      )
    end

    def image_params
      params.permit(:pic)
    end


    def comment_params
      params.permit(
        :title,
        :content,
        :user_id,
      )
    end
  end
end