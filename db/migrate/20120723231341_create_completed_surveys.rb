class CreateCompletedSurveys < ActiveRecord::Migration
  def change
    create_table :completed_surveys do |t|
      t.date :date
      t.belongs_to :user
      t.belongs_to :survey

      t.timestamps
    end
    add_index :completed_surveys, :user_id
    add_index :completed_surveys, :survey_id
  end
end
