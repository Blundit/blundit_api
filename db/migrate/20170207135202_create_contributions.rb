class CreateContributions < ActiveRecord::Migration[5.0]
  def change
    create_table :contributions do |t|

      t.timestamps
      t.integer "user_id"
      t.text "description"
    end
  end
end
