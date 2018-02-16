module Api::V1
  class ApiController < ApplicationController
    before_action :set_default_response_format

    def set_default_response_format
      request.format = :json
    end

    def authenticate_current_user
      head :unauthorized if get_current_user_2.nil?
    end

    def get_current_user_2
      if !request.headers['Access-Token'].nil?
        token = request.headers['Access-Token']
      elsif !request.headers['access-token'].nil?
        token = request.headers['access-token']
      end

      if !request.headers['Client'].nil?
        client = request.headers['Client']
      elsif !request.headers['client'].nil?
        client = request.headers['client']
      end

      if !request.headers['Uid'].nil?
        uid = request.headers['Uid']
      elsif !request.headers['uid'].nil?
        uid = request.headers['uid']
      end


      if !uid or !client or !token
        return nil
      end

      current_user = User.find_by(uid: uid)

      if current_user && current_user.tokens.has_key?(client)
          token = current_user.tokens[client]
          expiration_datetime = DateTime.strptime(token["expiry"].to_s, "%s")

          if expiration_datetime > DateTime.now
            @current_user = current_user
          end
      end

      @current_user
    end
  end
end