class CreateSelectedResponses < ActiveRecord::Migration
  def change
    create_table :selected_responses do |t|
      t.belongs_to :user
      t.belongs_to :response

      t.timestamps
    end
    add_index :selected_responses, :user_id
    add_index :selected_responses, :response_id
  end
end
