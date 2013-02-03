class AddAlertToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :alert, :boolean
  end
end
