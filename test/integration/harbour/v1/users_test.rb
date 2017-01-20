require 'test_helper'

module Harbour
  module V1
    class UsersTest < ApiTest
      test "api user must be authorized to access users" do
        assert_resource_is_unauthorized "users"
      end

      test "GET /api/users" do
        get '/api/users', authorized_headers
        assert_response :success
        p response_body
      end
    end
  end
end
