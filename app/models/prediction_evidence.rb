class PredictionEvidence < ApplicationRecord
    belongs_to :prediction
    belongs_to :evidence
end
