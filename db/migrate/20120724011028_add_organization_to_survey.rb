class AddOrganizationToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :organization_id, :integer
    add_index :surveys, :organization_id
  end
end
