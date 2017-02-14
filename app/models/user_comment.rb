class UserComment < ApplicationRecord
    belongs_to :user, touch: true
    belongs_to :comment
end
