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

    user.contributions << @contribution = Contribution.create({ user_id: user.id })
    @contribution.description = object.contributions[type].to_s
    @contribution.set_object(object)
    @contribution.save

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
end
