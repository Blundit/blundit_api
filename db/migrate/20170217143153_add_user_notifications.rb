class AddUserNotifications < ActiveRecord::Migration[5.0]
  def change
      add_column :users, 'notification_frequency', :string, default: 'as_they_happen'
  end
end
