class ClaimComment < ApplicationRecord
    belongs_to :claim
    belongs_to :comment
end
