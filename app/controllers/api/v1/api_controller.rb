module Api::V1
  class ApiController < ApplicationController
    before_action :set_default_response_format

    def set_default_response_format
      request.format = :json
    end

    def authenticate_current_user
    
      head :unauthorized if get_current_user.nil?
    end

    def get_current_user
      if request.headers['access-token'].nil? or request.headers['client'].nil? or request.headers['uid'].nil?
        return nil
      end

      current_user = User.find_by(uid: request.headers['uid'])

      if current_user && current_user.tokens.has_key?(request.headers["client"])
          token = current_user.tokens[request.headers["client"]]
          expiration_datetime = DateTime.strptime(token["expiry"].to_s, "%s")

          if expiration_datetime > DateTime.now
            @current_user = current_user
          end
      end

      @current_user
    end
  end
end