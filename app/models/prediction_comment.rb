class PredictionComment < ApplicationRecord
    belongs_to :prediction, touch: true, :counter_cache => true
    belongs_to :comment
end
