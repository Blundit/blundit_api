class PredictionEvidence < ApplicationRecord
    belongs_to :prediction, touch: true
    belongs_to :evidence
end
