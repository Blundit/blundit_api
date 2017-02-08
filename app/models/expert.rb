class Expert < ApplicationRecord
    has_many :contributions
    
    has_many :expert_claims, dependent: :destroy
    has_many :claims, :through => :expert_claims

    has_many :expert_categories, dependent: :destroy
    has_many :categories, :through => :expert_categories

    has_many :expert_comments, dependent: :destroy
    has_many :comments, :through => :expert_comments

    has_many :expert_predictions, dependent: :destroy
    has_many :predictions, :through => :expert_predictions

    has_many :expert_flags, dependent: :destroy
    has_many :flags, :through => :expert_flags

end
