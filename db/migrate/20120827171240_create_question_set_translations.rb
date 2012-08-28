class CreateQuestionSetTranslations < ActiveRecord::Migration
  def up
    QuestionSet.create_translation_table!({name: :string, description: :text}, migrate_data: true)
  end
  
  def down
    QuestionSet.drop_translation_table! migrate_data: true
  end
end
