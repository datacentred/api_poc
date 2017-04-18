class Role < ApplicationRecord
  ALLOWED_KEYS = ['roles.read', 'roles.modify', 'tickets.modify', 'usage.read', 'cloud.read', 'storage.read']
  has_and_belongs_to_many :users, -> { distinct }
  belongs_to :organization

  serialize :permissions

  validates :name, length: {minimum: 1}, allow_blank: false
  validate :permissions_are_valid

  after_initialize :generate_uuid
  before_destroy :check_power

  def permissions
    read_attribute(:permissions) || []
  end

  private

  def permissions_are_valid
    return true unless permissions.any?
    permissions.each do |permission|
      unless ALLOWED_KEYS.include?(permission)
        errors.add(:permissions, "must be one of: #{ALLOWED_KEYS.sort.map{|k| '\'' + k +'\'' }.join(', ')}. '#{permission}' is not allowed") 
        throw :abort
      end
    end
  end

  def generate_uuid
    if self.new_record? && valid?
      self.uuid = Digest::MD5.hexdigest(name) unless self.uuid
    end
  end

  def check_power
    if power_user?
      errors.add(:base, "The admin role cannot be removed")
      throw :abort
    end  
  end
end
