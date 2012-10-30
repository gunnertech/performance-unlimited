class CreateMappedDomains < ActiveRecord::Migration
  def change
    create_table :mapped_domains do |t|
      t.string :domain
      t.belongs_to :organization

      t.timestamps
    end
    add_index :mapped_domains, :organization_id
    add_index :mapped_domains, :domain
  end
end
