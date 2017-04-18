class CreateOrganizationsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations_users do |t|
      t.integer :organization_id, null: false
      t.integer :user_id, null: false
      t.boolean :primary, default: false, null: false
    end
  end
end
