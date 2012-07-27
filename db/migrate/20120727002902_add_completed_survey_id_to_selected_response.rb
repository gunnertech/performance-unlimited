class AddCompletedSurveyIdToSelectedResponse < ActiveRecord::Migration
  def change
    add_column :selected_responses, :completed_survey_id, :integer
    add_index :selected_responses, :completed_survey_id
  end
end
