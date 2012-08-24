class CreateRecordedMetrics < ActiveRecord::Migration
  def change
    create_table :recorded_metrics do |t|
      t.belongs_to :user
      t.string :value
      t.date :recorded_on

      t.timestamps
    end
    add_index :recorded_metrics, :user_id
  end
end
