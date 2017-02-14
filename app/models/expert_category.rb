class ExpertCategory < ApplicationRecord
    belongs_to :expert, touch: true
    belongs_to :category
end
