class CreateAssignedQuestionSets < ActiveRecord::Migration
  def change
    create_table :assigned_question_sets do |t|
      t.belongs_to :question_set
      t.belongs_to :survey
      t.integer :position

      t.timestamps
    end
    add_index :assigned_question_sets, :question_set_id
    add_index :assigned_question_sets, :survey_id
  end
end
