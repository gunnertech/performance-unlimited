class CreateAssignedSurveys < ActiveRecord::Migration
  def change
    create_table :assigned_surveys do |t|
      t.belongs_to :survey
      t.belongs_to :division

      t.timestamps
    end
    add_index :assigned_surveys, :survey_id
    add_index :assigned_surveys, :division_id
  end
end
