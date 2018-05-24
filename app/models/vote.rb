class Vote < ApplicationRecord
    belongs_to :user, :counter_cache => true

    has_one :vote_set
    has_one :claim, :through => :vote_set
    has_one :prediction, :through => :vote_set

    attr_reader :contributions_list
    def contributions_list
        {
                voted: "Voted",
        }
    end    

    def type?
        return "claim" if !self.claim.nil?
        return "prediction" if !self.prediction.nil?
    end

    def data
        return self.prediction if self.type? == "prediction"
        return self.claim if self.type? == "claim"
    end

    def self.claims
        arr = []
        ClaimVote.all.each do |cv|
            arr << cv.vote
        end

        return arr
    end

    def self.predictions
        arr = []
        PredictionVote.all.each do |cv|
            arr << cv.vote
        end

        return arr
    end
end
