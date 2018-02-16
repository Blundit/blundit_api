class VoteOverride < ApplicationRecord
  has_one :prediction
  has_one :claim
  has_one :user


  def type?
    return "claim" if !self.claim.nil?
    return "prediction" if !self.prediction.nil?
    return ""
  end


  def object
    return self.claim if !self.claim.nil?
    return self.prediction if !self.prediction.nil?
  end

end
