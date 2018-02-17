class VoteOverride < ApplicationRecord
  has_one :prediction
  has_one :claim
  has_one :user


  def type?
    return "claim" if !self.claim_id.nil?
    return "prediction" if !self.prediction_id..nil?
    return ""
  end


  def object
    return Claim.find(self.claim_id) if !self.claim_id.nil?
    return Prediction.find(self.prediction) if !self.prediction_id.nil?
  end

end
