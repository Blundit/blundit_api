class Contribution < ApplicationRecord
  belongs_to :user
  belongs_to :expert, optional: true
  belongs_to :claim, optional: true
  belongs_to :evidence, optional: true
  belongs_to :comment, optional: true
  belongs_to :flag, optional: true
  belongs_to :prediction, optional: true

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
