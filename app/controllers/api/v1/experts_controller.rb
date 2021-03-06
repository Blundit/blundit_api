module Api::V1
  class ExpertsController < ApiController
    before_action :authenticate_current_user, except: [:index, :show, :search, :comments, :all, :get_substantiations, :add_embed]
    before_action :set_expert, only: [:edit, :update, :destroy]
    before_filter :set_user, only: [:index, :show, :search, :comments]

    def index
      # GET /CONTROLLER
      @experts = Expert.do_search(params[:query], params[:sort]).includes(:expert_categories, :categories).order('created_at DESC').page(current_page).per(per_page)
      @current_page = current_page
      @per_page = per_page
    end


    def set_user
      current_user = get_current_user_2
    end


    def all
      # TODO: Limit to active
      @experts = Expert.all.order('name ASC')
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
        @expert = Expert.includes(expert_predictions: :prediction).includes(expert_claims: :claim).find_by_id(params[:id])
      else
        @expert = Expert.where(alias: params[:id]).includes(expert_predictions: :prediction).includes(expert_claims: :claim).first

        if @expert.nil?
          render json: { errors: "Expert Not Found" }, status: 422
        end
      end

      if !current_user.nil?
        @bookmark = current_user.bookmarks.find_by_expert_id(@expert.id)
      else
        @bookmark = nil
      end
      mark_as_read(@expert)
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

        if params.has_key?(:category)
          add_category(@expert, params[:category])
        end

        add_bookmark("expert", @expert.id)

        render json: { result: "success", expert: @expert }
      else
        render json: { result: "error" }
      end
    end


    # def edit
    #   # PUT /pundits/:id
    #   if @expert.update(expert_params)
    #     add_contribution(@expert, :edited_expert)
    #     add_bookmark("expert", @expert.id)

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

    #   #TODO: Mark item as invalid rather than destoying. (Would require changes in all and other querying to only return valid items)
    #   if params.has_key?(:id)
    #     if @expert.destroy
    #       add_contribution(@expert, :destroyed_expert)
    #       remove_bookmark(@expert.id, "expert")

    #       render json: { result: "success" }
    #     else
    #       render json: { result: "error" }
    #     end
    #   else
    #     render json: { result: "ID Not Found" }, status: 422
    #   end
    # end


    def search
      @expert = Expert.do_search(params[:query], params[:sort]).page(current_page).per(per_page)
      @current_page = current_page
      @per_page = per_page
    end


    def update_image
      if !params.has_key?(:expert_id) or !params.has_key?(:avatar)
        render json: { error: "Expert ID and Avatar required." }, status: 422
        return
      end

      @expert = Expert.find_by_id(params[:expert_id])

      if @expert.nil?
        render json: { error: "Expert not found" }, status: 422
        return
      end

      if @expert.update(image_params)
        add_contribution(@expert, :updated_image)
        render json: { status: "Success!" }
      else
        render json: { error: "There was an error updating" }, status:422
      end
    end


    def delete_image
      if !params.has_key?(:expert_id)
        render json: { error: "Expert ID required." }, status: 422
        return
      end

      @expert = Expert.find_by_id(params[:expert_id])

      if @expert.nil?
        render json: { error: "Expert not found" }, status: 422
        return
      end

      if @expert.delete_image
        add_contribution(@expert, :deleted_image)
        render json: { status: "Success!" }
      else
        render json: { error: "Error" }, status: 422
      end
    end


    def add_category(expert, category_id)

      if expert.nil?
        @expert = Expert.find_by_id(params[:expert_id])
      else
        @expert = expert
      end

      @category_source = 0
      if category_id.nil?
        @category_source = 1
        category_id = params[:category_id]
      end

      @category = Category.find_by_id(category_id)

      if @expert.nil?
        render json: { error: "Expert Not Found" }, status: 422
        return
      end

      if @category.nil?
        render json: { error: "Category Not Found" }, status: 422
        return
      end

      @expert.add_category_if_necessary(category_id, @category_source)
      if @expert.save
        add_contribution(@expert, :added_category)
        add_bookmark("expert", @expert.id)

        if params.has_key?(:expert_id)
          render json: { status: "success" }
        end

        attrs = {
          user_id: current_user.id,
          expert_id: @expert.id,
          item_type: "expert_claim_added",
          message: "Category #{@category.name} added to Expert"
        }
        NotificationQueue::delay.process(attrs)
      else
        if params.has_key?(:expert_id)
          render json: { error: "Unable to Add Category" }, status: 422
        end
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
        add_bookmark("expert", @expert.id)

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
        add_bookmark("expert", @expert.id)

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
        add_bookmark("expert", @expert.id)

        render json: { status: "Success" }
      else
        render json: { status: "Error" }
      end
    end


    def add_bona_fide
      # /experts/:expert_id/add_bona_fide
      @expert = Expert.find_by_id(params[:expert_id])

      if @expert.nil?
        render json: { error: 'Expert Not Found' }, status: 422
        return
      end

      if !params.has_key?(:url)
        render json: { error: "URL Required" }, status: 422
        return
      end

      @page = MetaInspector.new(params[:url], :allow_non_html_content => true)
      eob_params = {
          title: @page.best_title,
          description: @page.description,
          url: params[:url],
          expert_id: params[:expert_id],
          pic: @page.images.best
      }
      
      @bona_fide = BonaFide.create(eob_params)

      if @expert.bona_fides << @bona_fide
        add_contribution(@bona_fide, :created_bona_fide)
        add_contribution(@expert, :added_bona_fide)
        add_bookmark("expert", @expert.id)

        attrs = {
          user_id: current_user.id,
          expert_id: @expert.id,
          item_type: "expert_bona_fide_added",
          message: "Credential '#{@page.best_title}' added to Expert"
        }
        NotificationQueue::delay.process(attrs)

        render json: { status: 'success' }
      else
        render json: { error: 'Unable to Add Credential to Expert' }, status: 422
      end
    end

    
    def comments
      # TODO: Only pass relevant user details
      @expert = Expert.find_by_id(params[:expert_id])

      if @expert.nil?
        render json: { error: 'Expert Not Found' }, status: 422
        return
      end

      @comments = @expert.comments.order('created_at DESC').page(current_page).per(per_page)
      @page = current_page
      @per_page = per_page

    end


    def add_comment
      # /experts/:expert_id/add_comment
      @expert = Expert.find_by_id(params[:expert_id])

      if @expert.nil?
        render json: { error: 'Expert Not Found' }, status: 422
        return
      end

      params[:user_id] = current_user.id

      @comment = Comment.create(comment_params)

      if @expert.comments << @comment
        current_user.comments << @comment
        add_contribution(@expert, :added_comment)
        add_bookmark("expert", @expert.id)

        attrs = {
          user_id: current_user.id,
          comment_id: @comment.id,
          expert_id: @expert.id,
          item_type: "expert_comment_added",
          message: @comment.content
        }
        NotificationQueue::delay.process(attrs)

        render json: { status: "Success" }
      else
        render json: { status: "Error" }
      end
    end


    # remove comment is in application helper


    def add_claim
      @expert = Expert.find_by_id(params[:expert_id])
      @claim = Claim.find_by_id(params[:id])

      if @expert.nil?
        render json: { error: "Expert Not Found" }, status: 422
        return
      end

      if @claim.nil?
        render json: { error: "Claim Not Found" }, status: 422
        return
      end
      
      if params.has_key?(:id)
        if @expert.claims.where({id: params[:id]}).count > 0
          render json: { error: "This expert already has this claim." }, status: 422
          return
        end
        @claim.experts << @expert
        @expert.claims << @claim
        @expert.calc_accuracy

        if params.has_key?(:evidence_of_belief_url) and params[:evidence_of_belief_url].is_valid_url?
          add_evidence_of_belief(params[:evidence_of_belief_url], params[:id], "claim")
        end

        add_contribution(@expert, :added_claim)
        add_bookmark("expert", @expert.id)
        attrs = {
          user_id: current_user.id,
          claim_id: @claim.id,
          expert_id: @expert.id,
          item_type: "expert_claim_added",
          message: "#{@claim.title} added to Expert"
        }
        NotificationQueue::delay.process(attrs)

        render json: { status: "Success" }
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
        add_bookmark("expert", @expert.id)
        attrs = {
          user_id: current_user.id,
          claim_id: @claim.id,
          expert_id: @expert.id,
          item_type: "expert_claim_removed",
          message: "#{@claim.title} removed from Expert"
        }
        NotificationQueue::delay.process(attrs)

        render json: { status: "Success" }
      else
        render json: { status: "Error" }
      end
    end


    def add_prediction
      @expert = Expert.find_by_id(params[:expert_id])
      @prediction = Prediction.find_by_id(params[:id])


      if @expert.nil?
        render json: { error: "Expert not found" }, status: 422
        return
      end

      if @prediction.nil?
        render json: { error: "Prediction not found" }, status: 422
        return
      end
      
      if params.has_key?(:id)
        if @expert.predictions.where({id: params[:id]}).count > 0
          render json: { error: "This expert already has this prediction." }, status: 422
          return
        end
        @prediction.experts << @expert
        @expert.predictions << @prediction
        @expert.calc_accuracy
        add_contribution(@expert, :added_claim)
        add_bookmark("expert", @expert.id)

        if params.has_key?(:evidence_of_belief_url) and params[:evidence_of_belief_url].is_valid_url?
          add_evidence_of_belief(params[:evidence_of_belief_url], params[:id], "prediction")
        end

        attrs = {
          user_id: current_user.id,
          expert_id: @expert.id,
          prediction_id: @prediction.id,
          item_type: "expert_prediction_added",
          message: "#{@prediction.title} added to Expert"
        }
        NotificationQueue::delay.process(attrs)

        render json: { status: "Success" }
      else
        render json: { error: "Expert ID Not Found" }, status: 422
      end
    end


    def add_evidence_of_belief(url = nil, id = nil, type = nil)
      if params.has_key?(:url)
        @url = params[:url]
      else
        @url = url
      end

      if params.has_key?(:id)
        @id = params[:id]
      else
        @id = id
      end

      if params.has_key?(:type)
        @type = params[:type]
      else
        @type = type
      end

      if @url.nil? or @id.nil? or @type.nil?
        render json: { error: "URL, ID and Type required" }, status: 422
        return
      end

      @expert = Expert.find(params[:expert_id])
      @id = @id.to_i

      if @type == "prediction"
        @item = @expert.expert_predictions.find_by_prediction_id(@id)
      elsif @type == "claim"
        @item = @expert.expert_claims.find_by_claim_id(@id)
      end

      if @item.nil?
        render json: { error: "Specified Expert doesn't have #{@type} with id #{@id} attached" }, status: 422
        return
      end

      # TODO: call scraper as part of class that's applied site-wide
      @page = MetaInspector.new(@url, :allow_non_html_content => true)
      eob_params = {
          title: @page.best_title,
          domain: @page.host,
          description: @page.description,
          pic: @page.images.best,
          url: @url,
          url_content: @page.hash,
          expert_id: params[:expert_id]
      }

      eob_params["expert_#{@type}_id".to_sym] = @id

      if @item.evidence_of_beliefs << EvidenceOfBelief.create(eob_params)
        add_or_update_publication(@page.host)

        if @type == "prediction"
          @title = @item.prediction.title
        else
          @title = @item.claim.title
        end

        attrs = {
          expert_id: @expert.id,
          current_user: current_user.id,
          type: @type,
          item_id: @item.id,
          item_type: "expert_evidence_of_belief_added",
          content: "Evidence that Expert believes '#{@title}' added to Expert"
        }
        NotificationQueue::delay.process(attrs)

        if params.has_key?(:url)
          render json: { status: "Success" }
        else
          return true
        end
      else
        if params.has_key?(:url)
          render json: { status: "Error" }
        else
          return false
        end
      end
    end


    def get_substantiations
      if !params.has_key?(:expert_id) or !params.has_key?(:type) or !params.has_key?(:id)
        render json: { error: "Expert ID, Type and ID required" }, status: 422
        return
      end

      @expert = Expert.find(params[:expert_id])

      if params[:type] == "claim"
        @items = @expert.expert_claims.where({ claim_id: params[:id] })
      else
        @items = @expert.expert_predictions.where({ prediction_id: params[:id] })
      end

      if @items.length > 0
        @evidences = @items.first.evidence_of_beliefs
      else
        @evidences = []
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
        add_bookmark("expert", @expert.id)

        attrs = {
            user_id: current_user.id,
            prediction_id: @prediction.id,
            expert_id: @expert.id,
            item_type: "expert_prediction_removed",
            message: "#{@prediction.title} removed from Expert"
          }
          NotificationQueue::delay.process(attrs)
        render json: { status: "Success" }
      else
        render json: { status: "Error" }
      end
    end


    def add_embed
      # TODO: Track embed counts per claims, predictions, etc? For popularity?
      do_add_embed('expert')
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
          :city,
          :country,
          :website,
          :occupation,
          :tag_list,
          :wikipedia,
          :evidence_of_belief_url,
          :avatar
        )
    end


    def image_params
      params.permit(:avatar)
    end


    def bona_fide_params
      params.permit(
        :url,
        :description
      )
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