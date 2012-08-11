class AddPositionToAssignedGroups < ActiveRecord::Migration
  def change
    add_column :assigned_groups, :position, :integer
  end
end
