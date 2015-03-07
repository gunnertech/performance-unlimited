class AddAllowFreeFormResponeToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :allow_free_form_response, :boolean, default: false, null: false
  end
end
