class AddNameToPointRange < ActiveRecord::Migration
  def change
    add_column :point_ranges, :name, :string
    add_index :point_ranges, :name
  end
end
