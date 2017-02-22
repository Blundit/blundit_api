class CreateNotificationQueueItems < ActiveRecord::Migration[5.0]
  def change
    create_table :notification_queue_items do |t|
      t.integer "user_id"
      t.string "type" # determines email template
      t.integer "claim_id", null: true
      t.integer "prediction_id", null: true
      t.integer "expert_id", null: true
      t.integer "category_id", null: true
      t.string "message"
      t.integer "comment_id", null: true
      t.timestamps
    end
  end
end
