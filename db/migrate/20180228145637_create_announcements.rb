class CreateAnnouncements < ActiveRecord::Migration[5.0]
  def change
    create_table :announcements do |t|
      t.boolean :dismissable, :default => true
      t.text :announcement
      t.string :icon
      t.string :slug
      t.datetime :publish_at
      t.datetime :unpublish_at
      t.boolean :enabled, :default => false
      t.string :link
      t.string :link_text
      t.timestamps
    end
  end
end
