class ExpertClaim < ApplicationRecord
    belongs_to :expert
    belongs_to :claim
end
