class Comment < ApplicationRecord
    has_one :user
    
    belongs_to :claim_comment
    has_one :claim, :through => :claim_comment

    belongs_to :expert_comment
    has_one :expert, :through => :expert_comment

    belongs_to :prediction_comment
    has_one :prediction, :through => :prediction_comment
end
