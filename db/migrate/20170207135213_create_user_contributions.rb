class CreateUserContributions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_contributions do |t|

      t.timestamps
    end
  end
end
