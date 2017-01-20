# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require "rails/test_help"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new


# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

module Harbour
  class ApiTest < ActionDispatch::IntegrationTest
    def response_body
      JSON.parse(response.body)
    end

    def authorized_headers
      {params: { format: :dc_json }, headers: {authorization: "Token token=\"bill:ilovejoanna\""}}
    end

    def assert_resource_is_unauthorized(resource)
      statuses = []
      
      get "/api/#{resource}"
      statuses << response.status

      get "/api/#{resource}/1"
      statuses << response.status

      post "/api/#{resource}"
      statuses << response.status

      put "/api/#{resource}/1", params: {"foo": {"bar": "baz"}}
      statuses << response.status

      delete "/api/#{resource}/1"
      statuses << response.status

      assert statuses.all?{|s| s == 401 }
    end
  end
end
