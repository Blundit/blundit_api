class Flag < ApplicationRecord
    has_one :user

    belongs_to :claim_flag
    has_one :claim, :through => :claim_flag

    belongs_to :expert_flag
    has_one :expert, :through => :expert_flag

    belongs_to :prediction_flag
    has_one :prediction, :through => :prediction_flag
end
