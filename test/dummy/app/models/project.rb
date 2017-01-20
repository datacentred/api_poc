class Project < ApplicationRecord
  belongs_to :organization
  has_many :user_project_roles, dependent: :destroy
  has_many :users, -> { distinct }, :through => :user_project_roles
end
