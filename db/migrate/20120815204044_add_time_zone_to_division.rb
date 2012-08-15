class AddTimeZoneToDivision < ActiveRecord::Migration
  def change
    add_column :divisions, :time_zone, :string
  end
end
