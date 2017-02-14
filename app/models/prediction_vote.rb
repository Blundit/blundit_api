class PredictionVote < ApplicationRecord
    belongs_to :prediction, touch: true
    belongs_to :vote
end
