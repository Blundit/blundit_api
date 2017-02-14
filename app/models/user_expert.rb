class UserExpert < ApplicationRecord
    belongs_to :user, touch: true
    belongs_to :expert, touch: true
end
