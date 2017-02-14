class HomeController < ApplicationController
  # apply this to whatever location needs verification
  before_action :authenticate_request!, except: [:tester]
  
  def index
    render json: {'logged_in' => true}
  end

  def tester
    render json: {'exception' => true }
  end
end