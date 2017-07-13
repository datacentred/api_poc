module Billing
  class Usage < ApplicationRecord
    def self.find_by(params)
      OpenStruct.new(updated_at: Time.parse("2017-06-08 13:03:50 UTC"))
    end
  end
end
