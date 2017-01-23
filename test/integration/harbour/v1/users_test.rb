require 'test_helper'

module Harbour
  module V1
    class UsersTest < ApiTest
      def user_format
        {
          "uuid"       => String,
          "email"      => String,
          "first_name" => String,
          "last_name"  => String,
          "links"      => Array,
          "projects"   => Array
        }
      end

      test "api user must be authorized to access users" do
        assert_resource_is_unauthorized "users"
      end

      test "users index has two users" do
        get '/api/users', authorized_headers_and_params
        assert_response :success
        assert_equal 2, response_body['users'].count
      end

      test "users index users belong to org1" do
        get '/api/users', authorized_headers_and_params
        emails = response_body['users'].map{|u| u['email']}
        assert emails.include? "bill.s.preston@bodacious.com"
        assert emails.include? "elizabeth@ironmaiden.com"
      end

      test "index user matches format" do
        get '/api/users', authorized_headers_and_params
        user = response_body['users'][1]
        assert_format_matches user_format, user
      end

      test "can find user 1" do
        get '/api/users/1', authorized_headers_and_params
        assert_response :success
      end

      test "can't find user 2" do
        get '/api/users/2', authorized_headers_and_params
        assert_response :not_found
      end

      test "user 1 matches format" do
        get '/api/users/1', authorized_headers_and_params  
        assert_format_matches user_format, response_body['user']
      end

      test "create user succeeds with valid params" do
        params = {user: {email: 'death@afterlife.com', password: 'melvin'}}.merge(api_params)
        post '/api/users', params: params, headers: authorized_headers
        assert_response :created
        assert_operator response_body['uuid'].length, :>, 0
      end

      test "create user fails with invalid params" do
        params = {user: {email: 'death@afterlife.com'}}.merge(api_params)
        post '/api/users', params: params, headers: authorized_headers
        assert_response :unprocessable_entity
        p response.body
      end

      test "create user with project memberships" do
      end

      test "update user succeeds with valid params" do
      end

      test "update user fails with invalid params" do
      end

      test "update user with project memberships" do
      end

      test "change user password" do
      end

      test "delete user succeeds if user exists" do
      end

      test "delete user fails if user can't be found" do
      end

      test "delete user fails with suitable error if user can't be removed" do
        # e.g. if it's the current user
      end
    end
  end
end
