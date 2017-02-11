class Bookmark < ApplicationRecord
    belongs_to :user
    belongs_to :expert
    belongs_to :prediction
    belongs_to :claim

    def type?
        return "expert" if !self.expert.nil?
        return "claim" if !self.claim.nil?
    end

    def object
        return self.expert if !self.expert.nil?
        return self.claim if !self.claim.nil?
    end
end
