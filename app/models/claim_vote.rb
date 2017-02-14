class ClaimVote < ApplicationRecord
    belongs_to :claim, touch: true
    belongs_to :vote
end
