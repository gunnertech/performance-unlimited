class ChangeEmailOnUsers < ActiveRecord::Migration
  def up
    remove_index(:users, column: :email)
    add_index(:users, :email)
  end

  def down
    remove_index(:users, column: :email)
    add_index(:users, :email, unique: true)
  end
end
