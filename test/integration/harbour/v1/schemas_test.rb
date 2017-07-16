require 'test_helper'

module Harbour
  module V1
    class SchemasTest < ApiTest
      test "api user does not need to be authorized to access schemas" do
        get "/api/schemas/project", headers: valid_headers
        assert_response :success
      end

      test "existing schema is returned" do
        get '/api/schemas/project', headers: authorized_headers
        assert_response :success
        assert_equal "object", response_body['schema']['type']
      end

      test "non-existing schema returns 404" do
        get '/api/schemas/idontexist', headers: authorized_headers
        assert_response :not_found
      end
    end
  end
end
