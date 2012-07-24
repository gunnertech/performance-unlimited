class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :short_text
      t.text :long_text

      t.timestamps
    end
  end
end
