class CreateResponseTranslations < ActiveRecord::Migration
  def up
    Response.create_translation_table!({short_text: :string, long_text: :text}, migrate_data: true)
  end
  
  def down
    Response.drop_translation_table! migrate_data: true
  end
end
