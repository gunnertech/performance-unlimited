class AddFileContentsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :file_contents, :text
  end
end
