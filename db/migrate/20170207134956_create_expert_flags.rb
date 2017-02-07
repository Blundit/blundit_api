class CreateExpertFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :expert_flags do |t|

      t.timestamps
      t.integer "expert_id"
      t.integer "flag_id"
    end
  end
end
