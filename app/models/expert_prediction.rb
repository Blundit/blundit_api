class ExpertPrediction < ApplicationRecord
    belongs_to :expert
    belongs_to :prediction
end
