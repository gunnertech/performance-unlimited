class AddMeasuresDimensionToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :measures_dimension, :boolean
  end
end
