class PredictionComment < ApplicationRecord
    belongs_to :prediction, touch: true
    belongs_to :comment
end
