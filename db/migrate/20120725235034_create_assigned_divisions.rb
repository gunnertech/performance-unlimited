class CreateAssignedDivisions < ActiveRecord::Migration
  def change
    create_table :assigned_divisions do |t|
      t.belongs_to :division
      t.belongs_to :user

      t.timestamps
    end
    add_index :assigned_divisions, :division_id
    add_index :assigned_divisions, :user_id
  end
end
