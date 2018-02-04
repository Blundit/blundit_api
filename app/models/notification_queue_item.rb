class NotificationQueueItem < ApplicationRecord
    belongs_to :claim
    belongs_to :prediction
    belongs_to :expert
    belongs_to :comment
    belongs_to :category

    def type?
        return "expert" if !self.expert.nil?
        return "claim" if !self.claim.nil?
        return "evidence" if !self.evidence.nil?
        return "comment" if !self.comment.nil?
        return "category" if !self.category.nil?
        return "prediction" if !self.prediction.nil?

        return ""
    end


    def object
        return self.expert if !self.expert.nil?
        return self.claim if !self.claim.nil?
        return self.evidence if !self.evidence.nil?
        return self.comment if !self.comment.nil?
        return self.category if !self.category.nil?
        return self.prediction if !self.prediction.nil?
    end
end
