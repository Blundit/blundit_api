class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # protect_from_forgery with: :exception
  attr_reader :current_user


  def remove_bookmark(id = nil, find_type = nil)
    if params.has_key?(:bookmark_id)
      @id = params[:bookmark_id]
    elsif !id.nil?
      @id = params[:bookmark_id]
    else
      @id = id
    end

    if @id.nil?
      render json: { error: "Missing Data: id expected." }, status: 422
      return
    end

    if !find_type.nil?
      @id = Bookmark.where("#{find_type}_id = #{id} and user_id = #{current_user.id}").first.id
    end

    @bookmark = Bookmark.find(@id)

    if @bookmark.user_id != current_user.id
      render json: { error: "Can't remove bookmark belonging to other user." }, status: 422
    end

    attrs = {}
    attrs["user_id"] = @bookmark.user_id
    if !@bookmark.object.nil?
      attrs["#{@bookmark.type?}_id"] = @bookmark.object.id 
    end

    if @bookmark.destroy
      NotificationQueue::delay.prune_unnecessary_queue_items(attrs)
      
      if id.nil?
        render json: { status: "success" }
      else
        return true
      end
    else
      if id.nil?
        render json: { status: "error" }, status: 422
      else
        return false
      end
    end
  end
    

  def update_bookmark
    if params.has_key?(:bookmark_id)
      @id = params[:bookmark_id]
    end

    if @id.nil?
      render json: { error: "Missing Data: id expected." }, status: 422
      return
    end

    @bookmark = Bookmark.find(@id)

    if @bookmark.user_id != current_user.id
      render json: { error: "Can't remove bookmark belonging to other user." }, status: 422
    end

    @bookmark.notify = params[:notify]

    if @bookmark.save
      return true
    else
      return false
    end
  end


  def add_bookmark(type = nil, id = nil)
    if params.has_key?(:type)
      @type = params[:type]
    elsif !type.nil?
      @type = type
    end

    if params.has_key?(:id)
      @id = params[:id]
    elsif !id.nil?
      @id = id
    end

    if @type.nil? or @id.nil?
      render json: { error: "Missing Data: type and id expected." }, status: 422
      return
    end

    bookmark_params = { "user_id": current_user.id }
    bookmark_params["#{@type}_id".to_sym] = @id

    if Bookmark.where(bookmark_params).count == 0
      @bookmark = Bookmark.create(bookmark_params)
      if current_user.bookmarks << @bookmark
        if !type.nil?
          return true
        end
      else
        if !type.nil?
          return false
        else
          render json: { status: "Error creating bookmark" }, status: 422
        end
      end
    else
      if !type.nil?
          return false
        else
          render json: { status: "Item already bookmarked by user" }, status: 422
        end
    end
  end

  def do_add_embed(type)
    # TODO: Make this work with multiple embeds
    
    embed = Embed.new
    if !current_user.nil?
      embed.user_id = current_user.id
    end

    embed.title = params[:title]
    embed.description = params[:description]

    if embed.save
      embed_item = EmbedItem.new
      embed_item.embed_id = embed.id
      if type == 'claim'
        embed_item.claim_id = params[:claim_id]
      elsif type == 'prediction'
        embed_item.prediction_id = params[:prediction_id]
      elsif type == 'expert'
        embed_item.expert_id = params[:expert_id]
      end

      if embed_item.save
        @saved_embed = Embed.includes(:embed_items).find(embed.id)
        if request.port != 80 and request.port != 8080
          @port = ":" + request.port.to_s
        else
          @port = ""
        end

        @host = request.protocol + request.host + @port + "/embed/v1/show?key="
        render json: { message: "success", embed: @saved_embed, host: @host }
      else
        render json: { errors: "Unable to Add Embed Items" }, status: 422
      end
    else
      render json: { errors: "Unable to save Embed" }, status: 422
    end
  end


  String.class_eval do
      def is_valid_url?
          uri = URI.parse self
          uri.kind_of? URI::HTTP
            rescue URI::InvalidURIError
          false
      end
  end

  private

  def allow_iframe
    response.headers.delete "X-Frame-Options"
  end

  def add_contribution (object, type)
    if !@current_user
      # TODO : REMOVE THIS WHEN ACTUAL USER STUFF EXISTS
      user = User.find(1)
    else
      user = @current_user
    end

    @contribution = Contribution.new
    @contribution.user_id = user.id
    @contribution.description = object.contributions_list[type].to_s
    @contribution.set_object(object)
    if @contribution.save
      user.contributions << @contribution
    end
  end


  def add_or_update_publication (domain)
    @page = MetaInspector.new(domain, :allow_non_html_content => true)

    publication_params = {
      title: @page.best_title,
      domain: @page.host,
      description: @page.description,
      pic: @page.images.best,
    }

    if Publication.where({domain: domain}).count == 0            
      Publication.create(publication_params)
    else
      # TODO: Handle updating of publication data
    end
  end


  def current_page
    if params.has_key?(:page)
      @page = params[:page]
    else
      @page = 1
    end

    @page
  end


  def per_page
    if params.has_key?(:per_page)
      @per_page = params[:per_page]
    else
      @per_page = 12
    end

    @per_page
  end


  def mark_as_read(object)
    if current_user
      p object
      current_user.bookmarks.where("#{object.class.name.downcase}_id = ?", object.id).each do |bookmark|
        bookmark.update({ has_update: false })
      end
    end
  end

end
