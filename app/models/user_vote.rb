class UserVote < ApplicationRecord
    belongs_to :user, touch: true
    belongs_to :vote
end
