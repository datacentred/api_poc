require 'test_helper'

module Harbour
  class VersionControllerTest < ApiTest
    test "shows available versions without authorization headers" do
      get "/api/", params: { format: :dc_json }
      assert_equal Harbour::Engine.config.api_versions.count, response_body['versions'].count
      current_version = response_body['versions'].find{|v| v['status'] == 'CURRENT'}
      assert_equal Harbour::Engine.config.latest_api_version, "V#{current_version['id']}".to_sym
    end
  end
end
