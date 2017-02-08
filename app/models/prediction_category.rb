class PredictionCategory < ApplicationRecord
    belongs_to :prediction
    belongs_to :category
end
