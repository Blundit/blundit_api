class UserClaim < ApplicationRecord
    belongs_to :user
    belongs_to :claim
end
