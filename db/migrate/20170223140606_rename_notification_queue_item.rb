class RenameNotificationQueueItem < ActiveRecord::Migration[5.0]
  def change
    rename_column :notification_queue_items, :type, :item_type
  end
end
