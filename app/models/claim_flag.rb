class ClaimFlag < ApplicationRecord
    belongs_to :claim, touch: true
    belongs_to :flag
end
