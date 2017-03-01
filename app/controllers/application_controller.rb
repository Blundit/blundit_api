class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  attr_reader :current_user

  protected
  def authenticate_request!
    unless user_id_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
    @current_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  private

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


  def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
  end


  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end


  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end


  def current_page
    if params.has_key?(:page)
      @page = params[:page]
    else
      @page = 1
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

    if type.nil? or id.nil?
      render json: { error: "Missing Data: type and id expected." }, status: 422
      return
    end

    # TODO: remove
    current_user = User.first

    bookmark_params = { "user_id": current_user.id }
    bookmark_params["#{@type}_id".to_sym] = @id

    if Bookmark.where(bookmark_params).count == 0
      if current_user.bookmarks << Bookmark.create(bookmark_params)
        return true
      else
        return false
      end
    else
      return false
    end
  end


  def remove_bookmark(id = nil, find_type = nil)
    if params.has_key?(:id)
      @id = params[:id]
    elsif !id.nil?
      @id = params[:id]
    end

    if id.nil?
      render json: { error: "Missing Data: id expected." }, status: 422
      return
    end

    #TODO: remove
    current_user = User.first

    if !find_type.nil?
      id = Bookmark.where("#{find_type}_id = #{id} and user_id = #{current_user.id}").first.id
    end

    @bookmark = Bookmark.find(id)

    if @bookmark.user_id != current_user.id
      render json: { error: "Can't remove bookmark belonging to other user." }, status: 422
    end

    if Bookmark.find(params[:id]).destroy
      attrs = {}
      attrs["user_id"] = @bookmmark.user_id
      attrs["#{@bookmark.type?}_id"] = @bookmark.object.id 

      NotificationQueue::delay.prune_unnecessary_queue_items(attrs)
      
      return true
    else
      return false
    end
  end
    

  def update_bookmark
    if params.has_key?(:id)
      @id = params[:id]
    elsif !id.nil?
      @id = params[:id]
    end

    if id.nil?
      render json: { error: "Missing Data: id expected." }, status: 422
      return
    end

    @bookmark = Bookmark.find(params[:id])

    #TODO: remove
    current_user = User.first

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

end
