class PredictionComment < ApplicationRecord
    belongs_to :prediction
    belongs_to :comment
end
