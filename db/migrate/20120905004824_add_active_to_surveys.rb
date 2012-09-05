class AddActiveToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :active, :boolean, null: false, default: true
    
    Survey.update_all(active: true) rescue nil
    
  end
end
