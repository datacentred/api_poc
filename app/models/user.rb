class User < ApplicationRecord
  has_secure_password

  before_save :generate_access_key, on: :create

  private

  def generate_access_key
    return if access_key
    self.access_key = SecureRandom.urlsafe_base64
  end
end