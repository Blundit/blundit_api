class PredictionVote < ApplicationRecord
    belongs_to :prediction
    belongs_to :vote
end
