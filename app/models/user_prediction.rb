class UserPrediction < ApplicationRecord
    belongs_to :user, touch: true
    belongs_to :prediction, touch: true
end
