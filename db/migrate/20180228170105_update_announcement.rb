class UpdateAnnouncement < ActiveRecord::Migration[5.0]
  def change
    add_column :announcements, :announcement_key, :string, length: 32
  end
end
