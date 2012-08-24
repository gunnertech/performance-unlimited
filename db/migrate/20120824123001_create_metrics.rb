class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.belongs_to :metric_type
      t.belongs_to :organization
      t.string :name
      t.integer :decimal_places

      t.timestamps
    end
    add_index :metrics, :metric_type_id
    add_index :metrics, :organization_id
  end
end
