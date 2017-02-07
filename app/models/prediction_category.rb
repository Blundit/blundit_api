class PredictionCategory < ApplicationRecord
    has_one :prediction
    has_one :category
end
