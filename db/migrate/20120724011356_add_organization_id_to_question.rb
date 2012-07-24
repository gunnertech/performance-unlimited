class AddOrganizationIdToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :organization_id, :integer
    add_index :questions, :organization_id
  end
end
