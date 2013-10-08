class CreateAssignedAlerts < ActiveRecord::Migration
  def change
    create_table :assigned_alerts do |t|
      t.belongs_to :user
      t.belongs_to :alert
      t.belongs_to :recorded_metric
      t.date :date
      t.boolean :cleared

      t.timestamps
    end
    add_index :assigned_alerts, :user_id
    add_index :assigned_alerts, :alert_id
    add_index :assigned_alerts, :recorded_metric_id
  end
end
