class AddOrganizationIdToQuestionSet < ActiveRecord::Migration
  def change
    add_column :question_sets, :organization_id, :integer
    add_index :question_sets, :organization_id
  end
end
