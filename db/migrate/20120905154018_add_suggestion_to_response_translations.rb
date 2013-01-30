class AddSuggestionToResponseTranslations < ActiveRecord::Migration
  def up
    #add_column :response_translations, :suggestion, :text rescue nil
  end
  
  def down
    #remove_column :response_translations, :suggestion rescue nil
  end
end
