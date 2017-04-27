class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def created_at
    locked_time
  end

  def updated_at
    locked_time
  end

  private

  def locked_time
    Time.local(2017, 2, 1, 16, 20, 0).utc
  end
end
