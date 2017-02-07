class ClaimComment < ApplicationRecord
    has_one :claim
    has_one :comment
end
