class ExpertComment < ApplicationRecord
    belongs_to :expert, touch: true, :counter_cache => true
    belongs_to :comment
end
