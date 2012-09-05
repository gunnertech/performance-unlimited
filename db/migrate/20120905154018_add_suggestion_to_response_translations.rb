class AddSuggestionToResponseTranslations < ActiveRecord::Migration
  def up
    add_column :response_translations, :suggestion, :text
  end
  
  def down
    remove_column :response_translations, :suggestion
  end
end
