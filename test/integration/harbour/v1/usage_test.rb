require 'test_helper'

module Harbour
  module V1
    class UsageTest < ApiTest
      test "api user must be authorized to access usage" do
        get '/api/usage/2017/6', headers: valid_headers
        assert_equal 401, response.status
      end

      test "usage data matches format" do
        get '/api/usage/2017/6', headers: authorized_headers
        JSON::Validator.validate!(schema(1, "usage"), response_body)
      end

      test "usage returns successfully for existing year/month" do
        get '/api/usage/2017/6', headers: authorized_headers
        assert_response :success
        save_example "Get usage info"
      end

      test "usage not found for non-existing year/month in the past" do
        get '/api/usage/2012/6', headers: authorized_headers
        assert_response :not_found
        save_example "Usage info not found"
      end

      test "usage not found for non-existing year/month in the future" do
        get '/api/usage/2112/6', headers: authorized_headers
        assert_response :not_found
      end
    end
  end
end
