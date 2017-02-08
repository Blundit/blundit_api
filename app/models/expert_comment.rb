class ExpertComment < ApplicationRecord
    belongs_to :expert
    belongs_to :comment
end
