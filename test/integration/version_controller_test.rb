require 'test_helper'

class VersionControllerTest < ActionDispatch::IntegrationTest
  test "shows available versions" do
    get "/api/"
    p response.body
  end
end

