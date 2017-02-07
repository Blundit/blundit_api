class CreateFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :flags do |t|

      t.timestamps
      t.integer  "user_id"
      t.text     "description"
      t.text     "url"
    end
  end
end
