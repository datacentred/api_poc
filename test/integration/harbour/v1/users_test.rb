require 'test_helper'

module Harbour
  module V1
    class UsersTest < ApiTest
      test "api user must be authorized to access users" do
        assert_resource_is_unauthorized "users"
      end

      test "users index has two users" do
        get '/api/users', headers: authorized_headers
        assert_response :success
        assert_equal 2, response_body['users'].count
        save_example "Get users index"
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

        JSON::Validator.validate!(schema(1, "user"), user)
      end

      test "can find user 1" do
        get '/api/users',   headers: authorized_headers
        uuid = response_body['users'][0]['uuid']
        get "/api/users/#{uuid}", headers: authorized_headers
        assert_response :success
        save_example "Show user #{uuid}"
      end

      test "can't find user 2" do
        get '/api/users/not_found', headers: authorized_headers
        assert_response :not_found
        save_example "Can't find non-existent user"
      end

      test "user 1 matches format" do
        get '/api/users',   headers: authorized_headers
        uuid = response_body['users'][0]['uuid']
        get "/api/users/#{uuid}", headers: authorized_headers  
        user = response_body['user']
        JSON::Validator.validate!(schema(1, "user"), user)
      end

      test "create user succeeds with valid params" do
        params = {user: {email: 'death@afterlife.com', password: 'melvin'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        assert_response :created
        assert_operator response_body['user']['uuid'].length, :>, 0
        save_example "Create a new user with a password"
      end

      test "create user fails with invalid params" do
        params = {user: {email: 'death@afterlife.com'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
        assert_operator response_body['errors'].length, :>, 0
        assert_equal "user",     response_body['errors'][0]["resource"]
        assert_equal "password", response_body['errors'][0]["field"]
        save_example "Create a new user without a password"
      end

      test "update user succeeds with valid params" do
        params = {user: {email: 'death@afterlife.com', password: 'melvin'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        uuid = response_body['user']['uuid']
        params = {user: {first_name: 'Grim'}}
        put "/api/users/#{uuid}", params: params.to_json, headers: authorized_headers
        assert_response :ok
        assert_equal 'Grim', response_body['user']['first_name']
        save_example "Update user #{uuid} with a new first name"
      end

      test "update unknown user fails" do
        params = {user: {email: 'death@afterlife.com', password: 'melvin'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        params = {user: {first_name: 'Grim'}}
        put "/api/users/unknown", params: params.to_json, headers: authorized_headers
        assert_response :not_found
        save_example "Update a non-existent user"
      end

      test "update user fails with invalid params" do
        params = {user: {email: 'death@afterlife.com', password: 'melvin'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        uuid = response_body['user']['uuid']
        params = {user: {password: 'tiny'}}
        put "/api/users/#{uuid}", params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
        save_example "Update a user with a password that's too short"
      end

      test "change user password" do
        params = {user: {email: 'death@afterlife.com', password: 'melvin'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        uuid = response_body['user']['uuid']
        params = {user: {password: 'station'}}
        put "/api/users/#{uuid}", params: params.to_json, headers: authorized_headers
        assert_response :ok
      end

      test "delete user succeeds if user exists" do
        params = {user: {email: 'death@afterlife.com', password: 'melvin'}}
        post '/api/users', params: params.to_json, headers: authorized_headers
        uuid = response_body['user']['uuid']
        delete "/api/users/#{uuid}", headers: authorized_headers
        assert_response :no_content
        save_example "Delete a user"
      end

      test "delete user fails if user can't be found" do
        delete "/api/users/notarealuser", headers: authorized_headers
        assert_response :not_found
        save_example "Can't delete a non-existent user"
      end

      test "delete user fails with suitable error if user can't be removed" do
        delete "/api/users/#{current_user.uuid}", headers: authorized_headers
        assert_response :unprocessable_entity
        save_example "User can't delete themselves"
      end
    end
  end
end
