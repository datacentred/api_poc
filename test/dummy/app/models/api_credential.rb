class ApiCredential < ApplicationRecord
  has_secure_password
  belongs_to :user
  belongs_to :organization

  def authenticate_and_authorize(password)
    authenticate(password)
  end
end