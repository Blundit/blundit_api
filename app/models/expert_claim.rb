class ExpertClaim < ApplicationRecord
    belongs_to :expert, touch: true
    belongs_to :claim
end
