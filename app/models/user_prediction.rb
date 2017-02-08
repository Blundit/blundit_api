class UserPrediction < ApplicationRecord
    belongs_to :user
    belongs_to :prediction
end
