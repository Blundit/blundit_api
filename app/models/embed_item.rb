class EmbedItem < ApplicationRecord
  belongs_to :embed
  belongs_to :claim
  belongs_to :prediction
  belongs_to :expert

  def object
    if !claim_id.nil?
      return self.claim
    elsif !expert_id.nil?
      return self.expert
    elsif !prediction_id.nil?
      return self.prediction
    end
  end

  
  def type
    if !claim_id.nil?
      return "claim"
    elsif !expert_id.nil?
      return "expert"
    elsif !prediction_id.nil?
      return "prediction"
    end
  end

end
