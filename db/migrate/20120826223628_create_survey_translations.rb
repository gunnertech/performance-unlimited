class CreateSurveyTranslations < ActiveRecord::Migration
  def up
    Survey.create_translation_table!({name: :string}, migrate_data: true)
  end
  
  def down
    Survey.drop_translation_table! migrate_data: true
  end
end
