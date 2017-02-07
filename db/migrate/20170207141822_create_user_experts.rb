class CreateUserExperts < ActiveRecord::Migration[5.0]
  def change
    create_table :user_experts do |t|

      t.timestamps
      t.integer "user_id"
      t.integer "expert_id"
    end
  end
end
