class PredictionVote < ApplicationRecord
    belongs_to :prediction, touch: true, :counter_cache => true
    belongs_to :vote
end
