class ExpertClaim < ApplicationRecord
    belongs_to :expert, touch: true
    belongs_to :claim
    has_many :evidence_of_beliefs
end
