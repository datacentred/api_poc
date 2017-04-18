class OrganizationUser < ActiveRecord::Base
  self.table_name = 'organizations_users'

  belongs_to :organization
  belongs_to :user
end
