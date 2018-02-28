class AddTitleToAnnouncement < ActiveRecord::Migration[5.0]
  def change
    add_column :announcements, :title, :string
  end
end
