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

end
