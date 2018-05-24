class VoteSet < ApplicationRecord
  has_many :votes
  has_one :prediction
  has_one :claim
end
