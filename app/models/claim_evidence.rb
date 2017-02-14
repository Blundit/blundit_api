class ClaimEvidence < ApplicationRecord
    belongs_to :claim, touch: true
    belongs_to :evidence
end
