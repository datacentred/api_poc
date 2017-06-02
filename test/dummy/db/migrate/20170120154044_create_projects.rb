class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :uuid
      t.string :name
      t.integer :organization_id
      t.text :quota_set
      t.timestamps
    end
  end
end
