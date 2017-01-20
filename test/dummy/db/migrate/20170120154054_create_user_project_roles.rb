class CreateUserProjectRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_project_roles do |t|
      t.integer :user_id
      t.integer :project_id
      t.string  :role_id
      t.timestamps
    end
  end
end
