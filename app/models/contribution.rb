class Contribution < ApplicationRecord
  belongs_to :user
  belongs_to :expert
  belongs_to :claim
  belongs_to :evidence
  belongs_to :comment
  belongs_to :flag
  belongs_to :prediction

  def type?
    return "expert" if !self.expert.nil?
    return "claim" if !self.claim.nil?
    return "evidence" if !self.evidence.nil?
    return "comment" if !self.comment.nil?
    return "flag" if !self.flag.nil?
    return "prediction" if !self.prediction.nil?

    return ""
  end


  def object
    return self.expert if !self.expert.nil?
    return self.claim if !self.claim.nil?
    return self.evidence if !self.evidence.nil?
    return self.comment if !self.comment.nil?
    return self.flag if !self.flag.nil?
    return self.prediction if !self.prediction.nil?
  end


  def set_object(object)
    self["#{object.class.name.downcase}_id"] = object.id
    self.payload = object.as_json.to_s
  end
end
