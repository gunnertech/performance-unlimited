class CreateLocales < ActiveRecord::Migration
  def change
    create_table :locales do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
