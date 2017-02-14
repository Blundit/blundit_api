class ExpertComment < ApplicationRecord
    belongs_to :expert, touch: true
    belongs_to :comment
end
