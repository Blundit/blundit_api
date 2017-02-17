class Bookmark < ApplicationRecord
    belongs_to :user
    belongs_to :expert
    belongs_to :prediction
    belongs_to :claim

    def type?
        return "expert" if !self.expert.nil?
        return "claim" if !self.claim.nil?
        return "prediction" if !self.prediction.nil?
    end

    def object
        return self.expert if !self.expert.nil?
        return self.claim if !self.claim.nil?
        return self.prediction if !self.prediction.nil?
    end

    def do_notify
        self.update_attribute('notify', 1)
    end

    def dont_notify
        self.update_attribute('notify', 0)
    end
end
