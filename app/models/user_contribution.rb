class UserContribution < ApplicationRecord
    belongs_to :user, touch: true
    belongs_to :contribution
end
