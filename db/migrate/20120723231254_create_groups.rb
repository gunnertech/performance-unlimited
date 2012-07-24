class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.belongs_to :division

      t.timestamps
    end
    add_index :groups, :division_id
  end
end
