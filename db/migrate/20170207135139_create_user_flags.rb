class CreateUserFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :user_flags do |t|

      t.timestamps
    end
  end
end
