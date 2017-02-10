class Contribution < ApplicationRecord
  belongs_to :user
  has_one :expert
  has_one :claim
  has_one :evidence
  has_one :comment
  has_one :flag
  has_one :prediction

  def type?
    return "expert" if !self.expert.nil?
    return "claim" if !self.claim.nil?
    return "evidence" if !self.evidence.nil?
    return "comment" if !self.comment.nil?
    return "flag" if !self.flag.nil?
    return "prediction" if !self.prediction.nil?

    return ""
  end

  def set_object(object)
    self["#{object.class.name.downcase}_id"] = object.id
    self.payload = object.as_json.to_s
  end
end
