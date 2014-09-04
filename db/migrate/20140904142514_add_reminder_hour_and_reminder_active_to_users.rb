class AddReminderHourAndReminderActiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reminder_hour, :integer
    add_column :users, :reminder_active, :boolean, default: false
    add_index :users, :reminder_hour
  end
end
