class CreateAssignedQuestions < ActiveRecord::Migration
  def change
    create_table :assigned_questions do |t|
      t.belongs_to :question
      t.belongs_to :question_set
      t.integer :position

      t.timestamps
    end
    add_index :assigned_questions, :question_id
    add_index :assigned_questions, :question_set_id
  end
end
