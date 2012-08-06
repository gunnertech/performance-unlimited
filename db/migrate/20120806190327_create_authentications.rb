class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.string :nickname
      t.string :token
      t.string :secret
      t.string :authenticationable_type
      t.integer :authenticationable_id

      t.timestamps
    end
    
    add_index :authentications, [:authenticationable_id,:authenticationable_type], name: :a_id_and_a_type_on_authenticiations
    add_index :authentications, [:authenticationable_type,:authenticationable_id], name: :a_type_and_a_id_on_authenticiations
  end
end
