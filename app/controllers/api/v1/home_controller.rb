module Api::V1
  class HomeController < ApiController
    def homepage
      @homepage_items = 5
      # most recent predictions (active)
      @most_recent_active_predictions = Prediction.order('prediction_date DESC').where(["status = ? and prediction_date >= ? and prediction_date < ?", 0, (Time.now-2), Time.now]).limit(@homepage_items)
      # most recent predictions (settled)
      @most_recent_settled_predictions = Prediction.order('updated_at DESC').where({status: 1}).limit(@homepage_items)

      # most recent claims (active)
      @most_recent_active_claims = Claim.order('updated_at DESC').where({status: 0}).limit(@homepage_items)

      # most recent claims (settled)
      @most_recent_settled_claims = Claim.order('updated_at DESC').where({status: 0}).limit(@homepage_items)
      

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


    end
  end
end