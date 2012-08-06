class AddScoreToCompletedSurveys < ActiveRecord::Migration
  def change
    add_column :completed_surveys, :score, :integer
  end
end
