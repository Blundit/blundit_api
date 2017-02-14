class UserFlag < ApplicationRecord
    belongs_to :user, touch: true
    belongs_to :flag
end
