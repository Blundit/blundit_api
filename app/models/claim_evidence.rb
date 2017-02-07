class ClaimEvidence < ApplicationRecord
    has_one :claim
    has_one :evidence
end
