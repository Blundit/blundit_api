class ExpertPrediction < ApplicationRecord
    belongs_to :expert, touch: true
    belongs_to :prediction, touch: true
end
