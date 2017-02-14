class PredictionFlag < ApplicationRecord
    belongs_to :prediction, touch: true
    belongs_to :flag
end
