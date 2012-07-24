class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.string :name
      t.belongs_to :organization

      t.timestamps
    end
    add_index :divisions, :organization_id
  end
end
