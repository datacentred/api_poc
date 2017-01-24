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
        get '/api/users', headers: authorized_headers
        assert_response :success
        assert_equal 2, response_body['users'].count
      end

      test "users index users belong to org1" do
        get '/api/users', headers: authorized_headers
        emails = response_body['users'].map{|u| u['email']}
        assert emails.include? "bill.s.preston@bodacious.com"
        assert emails.include? "elizabeth@ironmaiden.com"
      end

      test "index user matches format" do
        get '/api/users', headers: authorized_headers
        user = response_body['users'][1]
        assert_format_matches user_format, user
      end

      test "can find user 1" do
        get '/api/users/1', headers: authorized_headers
        assert_response :success
      end

      test "can't find user 2" do
        get '/api/users/2', headers: authorized_headers
        assert_response :not_found
      end

      test "user 1 matches format" do
        get '/api/users/1', headers: authorized_headers  
        assert_format_matches user_format, response_body['user']
      end

      test "create user succeeds with valid params" do
        params = {user: {email: 'death@afterlife.com', password: 'melvin'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        assert_response :created
        assert_operator response_body['user']['uuid'].length, :>, 0
      end

      test "create user fails with invalid params" do
        params = {user: {email: 'death@afterlife.com'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
        assert_operator response_body['errors'].length, :>, 0
        assert_equal "user",     response_body['errors'][0]["resource"]
        assert_equal "password", response_body['errors'][0]["field"]
      end

      test "create user with project memberships" do
        skip
        params = {user: {email: 'death@afterlife.com', password: 'melvin', projects: ['1','2']}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        assert_response :created
        p response_body
      end

      test "update user succeeds with valid params" do
        params = {user: {email: 'death@afterlife.com', password: 'melvin'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        uuid = response_body['user']['uuid']
        params = {id: uuid, user: {first_name: 'Grim'}}
        put "/api/users/#{uuid}", params: params.to_json, headers: authorized_headers
        assert_response :ok
        assert_equal 'Grim', response_body['user']['first_name']
      end

      test "update user fails with invalid params" do
        params = {user: {email: 'death@afterlife.com', password: 'melvin'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        uuid = response_body['user']['uuid']
        params = {id: uuid, user: {password: 'tiny'}}
        put "/api/users/#{uuid}", params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
      end

      test "update user with project memberships" do
        skip
      end

      test "change user password" do
        params = {user: {email: 'death@afterlife.com', password: 'melvin'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        uuid = response_body['user']['uuid']
        params = {id: uuid, user: {password: 'station'}}
        put "/api/users/#{uuid}", params: params.to_json, headers: authorized_headers
        assert_response :ok
      end

      test "delete user succeeds if user exists" do
        params = {user: {email: 'death@afterlife.com', password: 'melvin'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        uuid = response_body['user']['uuid']
        delete "/api/users/#{uuid}", headers: authorized_headers
        assert_response :no_content
      end

      test "delete user fails if user can't be found" do
        delete "/api/users/notarealuser", headers: authorized_headers
        assert_response :not_found
      end

      test "delete user fails with suitable error if user can't be removed" do
        delete "/api/users/1", headers: authorized_headers
        assert_response :unprocessable_entity
      end
    end
  end
end
