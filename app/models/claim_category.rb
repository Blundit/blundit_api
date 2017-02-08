class ClaimCategory < ApplicationRecord
    belongs_to :claim
    belongs_to :category
end
