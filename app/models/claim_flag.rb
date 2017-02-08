class ClaimFlag < ApplicationRecord
    belongs_to :claim
    belongs_to :flag
end
