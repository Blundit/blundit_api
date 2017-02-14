class PredictionExpert < ApplicationRecord
    belongs_to :prediction, touch: true
    belongs_to :expert, touch: true
end
