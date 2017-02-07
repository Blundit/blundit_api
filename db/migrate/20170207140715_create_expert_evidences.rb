class CreateExpertEvidences < ActiveRecord::Migration[5.0]
  def change
    create_table :expert_evidences do |t|

      t.timestamps
      t.integer "expert_id"
      t.integer "evidence_id"
    end
  end
end
