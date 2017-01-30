# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'simplecov'
SimpleCov.start

require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require "rails/test_help"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

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
      valid_headers.dup.merge 'Authorization' => "Token token=\"bill:ilovejoanna\""
    end

    def valid_headers
      {
        'Accept'        => Mime::Type.lookup_by_extension(:dc_json).to_s,
        'Content-Type'  => Mime[:json].to_s
      }
    end

    def assert_resource_is_unauthorized(resource)
      statuses = []
      
      get "/api/#{resource}", headers: valid_headers
      statuses << response.status

      get "/api/#{resource}/1", headers: valid_headers
      statuses << response.status

      post "/api/#{resource}", headers: valid_headers
      statuses << response.status

      put "/api/#{resource}/1", params: {"foo": {"bar": "baz"}}.to_json, headers: valid_headers
      statuses << response.status

      delete "/api/#{resource}/1", headers: valid_headers
      statuses << response.status

      head "/api/#{resource}", headers: valid_headers
      statuses << response.status

      head "/api/#{resource}/1", headers: valid_headers
      statuses << response.status

      assert statuses.all?{|s| s == 401 }
    end

    def assert_format_matches(format, object)
      assert_equal format.keys, object.keys
      object.each do |k, v|
        assert_equal format[k], v.class
      end
    end

    def teardown
      DatabaseCleaner.clean
    end

    def save_example
      version   = Harbour.api_version(controller)
      base_file_path = Harbour::Engine.root.join("app/schema/harbour/v#{version}/examples/#{controller.controller_name}/#{controller.action_name}/")
      FileUtils.mkdir_p base_file_path
      file_path = "#{base_file_path}/#{response.status}.json"
      request_object = request.request_parameters
      request_object = nil if request_object&.values&.first == {}
      response_data = JSON.parse(response.body) rescue nil

      output = {
        "verb" => request.method,
        "path" => request.path,
        "request_data" => request_object,
        "response_data" => response_data,
        "head" => response.status,
        "api_version" => version
      }

      File.write(file_path, JSON.pretty_generate(output))
    end
  end
end
