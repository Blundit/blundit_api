class EmbedView < ApplicationRecord
  belongs_to :embed, touch: true, :counter_cache => true
end
