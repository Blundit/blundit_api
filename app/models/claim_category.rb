class ClaimCategory < ApplicationRecord
    belongs_to :claim, touch: true
    belongs_to :category
end
