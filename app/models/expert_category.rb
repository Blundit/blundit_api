class ExpertCategory < ApplicationRecord
    belongs_to :expert
    belongs_to :category
end
