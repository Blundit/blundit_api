class Contribution < ApplicationRecord
    belongs_to :user
    belongs_to :expert
    belongs_to :claim
    belongs_to :evidence
    belongs_to :comment
    belongs_to :flag
    belongs_to :prediction
end
