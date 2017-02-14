class ClaimComment < ApplicationRecord
    belongs_to :claim, touch: true
    belongs_to :comment
end
