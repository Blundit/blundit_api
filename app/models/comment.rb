class Comment < ApplicationRecord
    belongs_to :user
    
    has_one :claim_comment
    has_one :claim, :through => :claim_comment

    has_one :expert_comment
    has_one :expert, :through => :expert_comment

    has_one :prediction_comment
    has_one :prediction, :through => :prediction_comment
end
