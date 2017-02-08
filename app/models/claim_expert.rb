class ClaimExpert < ApplicationRecord
    belongs_to :claim
    belongs_to :expert
end
