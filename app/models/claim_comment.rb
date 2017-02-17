class ClaimComment < ApplicationRecord
    belongs_to :claim, touch: true, :counter_cache => :true
    belongs_to :comment
end
