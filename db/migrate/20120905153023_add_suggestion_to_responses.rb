class AddSuggestionToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :suggestion, :text
  end
end
