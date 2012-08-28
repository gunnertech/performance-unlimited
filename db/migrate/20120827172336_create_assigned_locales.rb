class CreateAssignedLocales < ActiveRecord::Migration
  def change
    create_table :assigned_locales do |t|
      t.belongs_to :locale
      t.belongs_to :organization

      t.timestamps
    end
    add_index :assigned_locales, :locale_id
    add_index :assigned_locales, :organization_id
  end
end
