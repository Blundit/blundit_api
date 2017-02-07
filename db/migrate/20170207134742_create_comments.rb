class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.timestamps
      t.integer  "user_id"
      t.string   "title"
      t.text     "content"
    end
  end
end
