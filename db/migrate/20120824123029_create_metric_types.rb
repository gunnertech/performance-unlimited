class CreateMetricTypes < ActiveRecord::Migration
  def change
    create_table :metric_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
