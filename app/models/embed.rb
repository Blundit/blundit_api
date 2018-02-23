class Embed < ApplicationRecord
  has_one :user
  has_many :embed_items
  has_many :embed_views

  before_validation :set_key

  attr_accessor :host

  def set_key
    if self.embed_key.nil?
      self.embed_key = ([*('a'..'z'),*('0'..'9')]-%w(0 1 I O)).sample(32).join
    end
  end
end
