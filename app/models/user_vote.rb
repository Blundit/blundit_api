class UserVote < ApplicationRecord
    belongs_to :user, touch: true, :counter_cache => true
    belongs_to :vote
end
