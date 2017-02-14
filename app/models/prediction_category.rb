class PredictionCategory < ApplicationRecord
    belongs_to :prediction, touch: true
    belongs_to :category
end
