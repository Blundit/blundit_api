class UserFlag < ApplicationRecord
    belongs_to :user
    belongs_to :flag
end
