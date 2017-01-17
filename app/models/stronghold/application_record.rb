module Stronghold
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    establish_connection STRONGHOLD_DB
  end
end