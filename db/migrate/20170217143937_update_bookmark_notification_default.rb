class UpdateBookmarkNotificationDefault < ActiveRecord::Migration[5.0]
  def change
      change_column :users, :notification_frequency, :integer, default: 1
  end
end
