module Api::V1
  class HomeController < ApiController
    def most_popular
      @most_popular_items = 10
      # most popular experts
      @most_popular_experts = Expert.most_popular('alltime', @most_popular_items)

      # most popular predictions
      @most_popular_predictions = Prediction.most_popular('alltime', @most_popular_items)

      # most popular claims
      @most_popular_claims = Claim.most_popular('alltime', @most_popular_items)
    end
  end
end