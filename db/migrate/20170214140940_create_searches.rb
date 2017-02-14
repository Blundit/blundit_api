class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.string :user_id, :integer
      t.string :query, :text

      t.timestamps
    end
  end
end
