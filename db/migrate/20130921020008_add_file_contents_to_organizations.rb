class AddFileContentsToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :file_contents, :text
  end
end
