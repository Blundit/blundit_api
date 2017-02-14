class ClaimExpert < ApplicationRecord
    belongs_to :claim, touch: true
    belongs_to :expert, touch: true
end
