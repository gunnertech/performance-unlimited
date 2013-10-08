class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :alertable_type
      t.integer :alertable_id
      t.string :message
      t.belongs_to :metric
      t.float :threshold_minimum
      t.float :threshold_maximum

      t.timestamps
    end
    add_index :alerts, :metric_id
    add_index :alerts, [:alertable_id, :alertable_type]
  end
end
