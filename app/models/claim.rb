class Claim < ApplicationRecord
    has_many :contributions
    
    has_many :claim_experts, dependent: :destroy
    has_many :experts, :through => :claim_experts

    has_many :claim_categories, dependent: :destroy
    has_many :categories, :through => :claim_categories

    has_many :claim_votes, dependent: :destroy
    has_many :votes, :through => :claim_votes

    has_many :claim_evidences, dependent: :destroy
    has_many :evidences, :through => :claim_evidences

    has_many :claim_flags, dependent: :destroy
    has_many :flags, :through => :claim_flags

    has_many :claim_comments, dependent: :destroy
    has_many :comments, :through => :claim_comments
end
