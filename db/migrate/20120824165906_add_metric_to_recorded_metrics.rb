class AddMetricToRecordedMetrics < ActiveRecord::Migration
  def change
    add_column :recorded_metrics, :metric_id, :integer
    add_index :recorded_metrics, :metric_id
  end
end
