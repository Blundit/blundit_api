class CreateEvidences < ActiveRecord::Migration[5.0]
  def change
    create_table :evidences do |t|

      t.timestamps
      t.string "title"
      t.string "url"
      t.text "description"
    end
  end
end
