class UserClaim < ApplicationRecord
    belongs_to :user, touch: true
    belongs_to :claim, touch: true
end
