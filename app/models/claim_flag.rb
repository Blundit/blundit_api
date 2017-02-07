class ClaimFlag < ApplicationRecord
    has_one :claim
    has_one :flag
end
