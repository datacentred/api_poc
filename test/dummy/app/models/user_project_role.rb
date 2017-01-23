class UserProjectRole < ApplicationRecord
  belongs_to :user
  belongs_to :project

  def self.required_role_ids
    'foo'
  end
end
