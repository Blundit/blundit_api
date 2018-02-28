class Announcement < ApplicationRecord
  def self.active
    where("publish_at >= ? and unpublish_at <= ? or enabled = ?", Time.now, Time.now, true)
  end

  def self.get(slug)
    self.active.where({slug: slug})
  end

  before_validation :set_key
  
  def set_key
    new_key = ([*('a'..'z'),*('0'..'9')]-%w(0 1 I O)).sample(32).join

    while Announcement.where({ announcement_key: new_key }).count > 0 do
      new_key = ([*('a'..'z'),*('0'..'9')]-%w(0 1 I O)).sample(32).join
    end
    
    self.announcement_key = new_key
  end
end
