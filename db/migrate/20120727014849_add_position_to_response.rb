class AddPositionToResponse < ActiveRecord::Migration
  def change
    add_column :responses, :position, :integer
  end
end
