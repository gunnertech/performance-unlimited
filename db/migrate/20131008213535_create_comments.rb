class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :by_user_id
      t.integer :for_user_id
      t.text :body
      t.belongs_to :metric

      t.timestamps
    end
    add_index :comments, :metric_id
    add_index :comments, :by_user_id
    add_index :comments, :for_user_id
  end
end
