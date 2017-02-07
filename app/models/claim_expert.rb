class ClaimExpert < ApplicationRecord
    has_one :claim
    has_one :expert
end
