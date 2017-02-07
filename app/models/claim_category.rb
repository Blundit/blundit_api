class ClaimCategory < ApplicationRecord
    has_one :claim
    has_one :category
end
