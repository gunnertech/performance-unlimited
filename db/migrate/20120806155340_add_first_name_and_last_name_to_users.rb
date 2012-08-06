class AddFirstNameAndLastNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    
    User.all.each do |user|
      user.set_first_name_and_last_name
      user.save!
    end
  end
  
  def self.down
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
  end
end
