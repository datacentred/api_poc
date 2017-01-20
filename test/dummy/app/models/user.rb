class User < ApplicationRecord
  belongs_to :organization
  has_many :api_credentials
  has_many :user_project_roles, dependent: :destroy
  has_many :projects, -> { distinct }, :through => :user_project_roles
end
