class ExpertCategory < ApplicationRecord
    has_one :expert
    has_one :category
end
