class AddNoteToMetric < ActiveRecord::Migration
  def change
    add_column :metrics, :note, :string
  end
end
