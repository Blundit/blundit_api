module Api::V1
  class HomeController < ApiController
    def homepage
      @homepage_items = 4
      @most_popular_items = 10
      # most recent predictions (active)
      @most_recent_active_predictions = Prediction.order('prediction_date DESC').where(["status = ? and prediction_date <= ?", 0, Time.now]).limit(@homepage_items)
      
      # most recent predictions (settled)
      @most_recent_settled_predictions = Prediction.order('updated_at DESC').where({status: 1}).limit(@homepage_items)

      # most recent claims (active)
      @most_recent_active_claims = Claim.order('updated_at DESC').where({status: 0}).limit(@homepage_items)

      # most recent claims (settled)
      @most_recent_settled_claims = Claim.order('updated_at DESC').where({status: 1}).limit(@homepage_items)
      

      # random expert
      offset = rand(Expert.count)
      @random_expert = Expert.offset(offset).first

      # random claim
      offset = rand(Claim.count)
      @random_claim = Claim.offset(offset).first

      # random prediction
      offset = rand(Prediction.count)
      @random_prediction = Prediction.offset(offset).first

      # most accurate experts
      @most_accurate_experts = Expert.order('accuracy DESC').limit(@homepage_items)

      # least accurate axperts
      @least_accurate_experts = Expert.order('accuracy ASC').limit(@homepage_items)

      # most popular experts
      @most_popular_experts = Expert.order('expert_comments_count DESC').limit(@most_popular_items)

      # most popular predictions
      @most_popular_predictions = Prediction.order('prediction_comments_count DESC').limit(@most_popular_items)

      # most popular claims
      @most_popular_claims = Claim.order('claim_comments_count DESC').limit(@most_popular_items)
    end


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