class ClaimEvidence < ApplicationRecord
    belongs_to :claim
    belongs_to :evidence
end
