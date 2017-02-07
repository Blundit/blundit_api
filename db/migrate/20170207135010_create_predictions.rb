class CreatePredictions < ActiveRecord::Migration[5.0]
  def change
    create_table :predictions do |t|

      t.timestamps
      t.string "title"
      t.text "description"
      t.integer "status"
      t.integer "vote_count"
      t.integer "vote_value"
    end
  end
end
