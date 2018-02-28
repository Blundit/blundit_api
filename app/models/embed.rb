class Embed < ApplicationRecord
  has_one :user
  has_many :embed_items
  has_many :embed_views

  before_validation :set_key
  # TODO: Make sure set_key returns a unique key

  attr_accessor :host

  def set_key
    new_key = ([*('a'..'z'),*('0'..'9')]-%w(0 1 I O)).sample(32).join

    if self.embed_key.nil?
      while Embed.where({ embed_key: new_key }).count > 0 do
        new_key = ([*('a'..'z'),*('0'..'9')]-%w(0 1 I O)).sample(32).join
      end
      
      self.embed_key = new_key
    end
  end
end
