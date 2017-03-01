class EvidenceOfBelief < ApplicationRecord
    has_one :expert_prediction
    has_one :expert_claim
end
