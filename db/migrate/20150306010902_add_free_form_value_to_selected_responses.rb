class AddFreeFormValueToSelectedResponses < ActiveRecord::Migration
  def change
    add_column :selected_responses, :free_form_value, :string
  end
end
