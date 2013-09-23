class AddNumericalValueToRecordedMetrics < ActiveRecord::Migration
  def up
    add_column :recorded_metrics, :numerical_value, :decimal, precision: 8, scale: 2
    RecordedMetric.joins{ metric_type }.where{ metric_type.name != 'Text' }.each do |r|
      rm = RecordedMetric.find(r.id)
      rm.numerical_value = rm.value.to_d
      rm.save!
    end
  end
  
  def down
    remove_column :recorded_metrics, :numerical_value
  end
end
