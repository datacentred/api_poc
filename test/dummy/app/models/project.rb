class Project < ApplicationRecord
  belongs_to :organization
  has_many :user_project_roles, dependent: :destroy
  has_many :users, -> { distinct }, :through => :user_project_roles

  validates :name, :uniqueness => true

  validate :check_quota_set_is_valid, on: [:create, :update]

  after_initialize :generate_uuid

  serialize :quota_set

  def quota_set
    read_attribute(:quota_set) || StartingQuota['standard']
  end

  def quota_set=(hash)
    write_attribute :quota_set, (read_attribute(:quota_set) || StartingQuota['standard']).deep_merge(hash)
  end

  private

  def generate_uuid
    if self.new_record? && valid?
      self.uuid = Digest::MD5.hexdigest(name) unless self.uuid
    end
  end

  def check_quota_set_is_valid
    quotas = quota_set.stringify_keys!
    unless quotas.is_a? Hash
      errors.add(:quota_set, "must be a hash")
      throw :abort
    end
    unless quotas.keys.all?{|k| StartingQuota['standard'].keys.include? k}
      errors.add(:quota_set, "top level keys are invalid. Valid keys are #{StartingQuota['standard'].keys}")
      throw :abort
    end
    StartingQuota['standard'].each do |top_level_key, sub_quotas|
      next unless quotas[top_level_key]
      unless quotas[top_level_key].is_a? Hash
        errors.add(:quota_set, "must be a hash")
        throw :abort
      end
      quotas[top_level_key].stringify_keys!
      unless quotas[top_level_key].keys.all?{|k| sub_quotas.keys.include? k}
        errors.add(:quota_set, "#{top_level_key} keys are invalid. Valid keys are #{StartingQuota['standard'][top_level_key].keys}.")
        throw :abort
      end
      (errors.add(:quota_set, "values must all be numeric") && break) unless quotas[top_level_key].values.all? {|v| Integer(v.to_s) rescue false }
      errors.add(:quota_set, "values must all be above zero") unless quotas[top_level_key].values.all? {|v| Integer(v.to_s) > 0 }
    end
    throw :abort if errors.any?
  end

end
