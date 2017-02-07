class ClaimVote < ApplicationRecord
    has_one :claim
    has_one :vote
end
