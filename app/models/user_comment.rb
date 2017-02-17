class UserComment < ApplicationRecord
    belongs_to :user, touch: true, :counter_cache => true
    belongs_to :comment
end
