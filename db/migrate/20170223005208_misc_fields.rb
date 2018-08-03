class MiscFields < ActiveRecord::Migration[5.0]
  def change
    add_column :users, "first_name", :string
    add_column :users, "last_name", :string

    # add_column :notification_queue_items, "category_id", :integer

  end
end
