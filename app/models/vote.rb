class Vote < ApplicationRecord
    has_one :user
    belongs_to :claim
    belongs_to :prediction
end
