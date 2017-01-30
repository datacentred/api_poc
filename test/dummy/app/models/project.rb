class Project < ApplicationRecord
  belongs_to :organization
  has_many :user_project_roles, dependent: :destroy
  has_many :users, -> { distinct }, :through => :user_project_roles

  validates :name, :uniqueness => true

  after_initialize :generate_uuid

  private

  def generate_uuid
    if self.new_record? && valid?
      self.uuid = Digest::MD5.hexdigest(name) unless self.uuid
    end
  end
end
