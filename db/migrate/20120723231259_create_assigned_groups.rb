class CreateAssignedGroups < ActiveRecord::Migration
  def change
    create_table :assigned_groups do |t|
      t.belongs_to :group
      t.belongs_to :user

      t.timestamps
    end
    add_index :assigned_groups, :group_id
    add_index :assigned_groups, :user_id
  end
end
