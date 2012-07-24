class CreatePointRanges < ActiveRecord::Migration
  def change
    create_table :point_ranges do |t|
      t.belongs_to :assigned_survey
      t.integer :low
      t.integer :high
      t.text :description

      t.timestamps
    end
    add_index :point_ranges, :assigned_survey_id
  end
end
