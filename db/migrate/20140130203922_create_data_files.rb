class CreateDataFiles < ActiveRecord::Migration
  def change
    create_table :data_files do |t|
      t.string :data_fileable_type
      t.integer :data_fileable_id
      t.text :file_contents
      t.boolean :processing, default: false

      t.timestamps
    end
    
    add_index :data_files, [:data_fileable_type, :data_fileable_id]
  end
end

