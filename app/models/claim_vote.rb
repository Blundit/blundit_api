class ClaimVote < ApplicationRecord
    belongs_to :claim
    belongs_to :vote
end
