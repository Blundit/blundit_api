class Category < ApplicationRecord
    has_many :claim_categories, dependent: :destroy
    has_many :claims, :through => :claim_categories
    
    has_many :expert_categories, dependent: :destroy
    has_many :experts, :through => :expert_categories

    has_many :prediction_categories, dependent: :destroy
    has_many :predictions, :through => :prediction_categories
end
