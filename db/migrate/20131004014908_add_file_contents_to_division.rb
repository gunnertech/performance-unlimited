class AddFileContentsToDivision < ActiveRecord::Migration
  def change
    add_column :divisions, :file_contents, :text
  end
end
