class AddQuestionIdToSelectedResponse < ActiveRecord::Migration
  def change
    add_column :selected_responses, :question_id, :integer
    add_index :selected_responses, :question_id
    
    begin
      SelectedResponse.where{ question_id == nil }.each do |sr|
        sr.question_id = sr.response.question.id rescue nil
        sr.save!
      end
    rescue
    end
  end
end
