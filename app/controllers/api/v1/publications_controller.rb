module Api::V1
  class PublicationsController < ApiController
    before_action :set_publication, only: [:edit, :update, :destroy]

    def index
      @publications = Publication.page(current_page)
    end


    def show
      if params[:id] == 'search' && !params[:term].nil?
        return self.search
      end
    end


    def new
      # GET /pundits/new
      @prediction = Prediction.new
    end


    def create

    end


    def edit

    end


    def destroy

    end


    def search
      @publications = Publication.do_search(params[:term])
    end


    private

    def set_publication
      @publication = Publication.find(params[:id])
    end

  end
end