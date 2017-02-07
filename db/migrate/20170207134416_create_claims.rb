class CreateClaims < ActiveRecord::Migration[5.0]
  def change
    create_table :claims do |t|
      t.timestamps
      t.string   "title"
      t.text     "description"
      t.string   "url"
      t.datetime "added"
      t.float    "accuracy"
    end
  end
end
