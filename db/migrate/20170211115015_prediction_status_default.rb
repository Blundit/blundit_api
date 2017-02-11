class PredictionStatusDefault < ActiveRecord::Migration[5.0]
  def change
    change_column :predictions, :status, :integer, default: 0

    Prediction.all.each do |p|
      if p.status.nil?
        p.status = 0
        p.save
      end
    end
  end
end
