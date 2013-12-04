class AddPositionToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :position, :integer
    Metric.update_all(position: 99) rescue nil
  end
end
