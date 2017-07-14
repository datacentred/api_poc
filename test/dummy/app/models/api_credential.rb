class ApiCredential < ApplicationRecord
  has_secure_password
  belongs_to :user
  belongs_to :organization

  scope :enabled, -> { where(enabled: true) }

  def authenticate_and_authorize(password)
    authenticate(password)
  end
end