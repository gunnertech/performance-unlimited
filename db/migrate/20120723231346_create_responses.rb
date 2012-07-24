class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.belongs_to :question
      t.string :short_text
      t.string :long_text
      t.integer :points

      t.timestamps
    end
    add_index :responses, :question_id
  end
end
