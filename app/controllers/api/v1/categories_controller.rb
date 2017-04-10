module Api::V1
    class CategoriesController < ApiController
        def index
            @categories = Category.all.order('name ASC')
        end


        def show
            @category = Category.find(params[:id])
        end


        def show_all
            @category = Category.find(params[:category_id])

            @experts = @category.experts
            @claims = @category.claims
            @predictions = @category.predictions
        end


        def show_experts
            @category = Category.find(params[:category_id])

            @experts = @category.experts
        end


        def show_claims
            @category = Category.find(params[:category_id])

            @claims = @category.claims
        end 


        def show_predictions
            @category = Category.find(params[:category_id])
            
            @predictions = @category.predictions
        end



    end
end