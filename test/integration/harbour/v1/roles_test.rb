require 'test_helper'

module Harbour
  module V1
    class RolesTest < ApiTest
      test "api user must be authorized to access roles" do
        assert_resource_is_unauthorized "roles"
      end

      test "roles index has two roles" do
        get '/api/roles', headers: authorized_headers
        assert_response :success
        assert_equal 2, response_body['roles'].count
        save_example "Get roles index"
      end

      test "roles index roles belong to org1" do
        get '/api/roles', headers: authorized_headers
        names = response_body['roles'].map{|u| u['name']}
        assert names.include? "Administrator"
        assert names.include? "Empty"
      end

      test "index role matches format" do
        get '/api/roles', headers: authorized_headers
        role = response_body['roles'][1]
        JSON::Validator.validate!(schema(1, "role"), role)
      end

      test "can find role 1" do
        get '/api/roles',   headers: authorized_headers
        id = response_body['roles'][0]['id']
        get "/api/roles/#{id}", headers: authorized_headers
        assert_response :success
        save_example "Show role #{id}"
      end

      test "can't find role 2" do
        get '/api/roles/not_found', headers: authorized_headers
        assert_response :not_found
        save_example "Can't find non-existent role"
      end

      test "role 1 matches format" do
        get '/api/roles',   headers: authorized_headers
        id = response_body['roles'][0]['id']
        get "/api/roles/#{id}", headers: authorized_headers  
        role = response_body['role']
        JSON::Validator.validate!(schema(1, "role"), role)
      end

      test "create role succeeds with valid params" do
        params = {role: {name: 'Historical Figures', permissions: ["usage.read", "tickets.modify"]}}
        post '/api/roles', params: params.to_json, headers: authorized_headers
        assert_response :created
        assert_operator response_body['role']['id'].length, :>, 0
        save_example "Create a new role with basic permissions"
      end

      test "create admin role succeeds but is ignored" do
        params = {role: {name: 'zomg admin', admin: true}}
        post '/api/roles', params: params.to_json, headers: authorized_headers
        assert_response :created
        refute response_body['role']['admin']
      end

      test "create role fails with invalid params" do
        params = {role: {name: 'Genghis Khan', permissions: ["fighting"]}}
        post '/api/roles', params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
        assert_operator response_body['errors'].length, :>, 0
        assert_equal "role",        response_body['errors'][0]["resource"]
        assert_equal "permissions", response_body['errors'][0]["field"]
        save_example "Create a new role with invalid permissions"
      end

      test "update role succeeds with valid params" do
        params = {role: {name: "Waterslide"}}
        post '/api/roles', params: params.to_json, headers: authorized_headers
        id = response_body['role']['id']
        params = {role: {permissions: ['usage.read']}}
        put "/api/roles/#{id}", params: params.to_json, headers: authorized_headers
        assert_response :ok
        assert response_body['role']['permissions'].include? 'usage.read'
        save_example "Update role #{id} with new permissions"
      end

      test "update unknown role fails" do
        params = {role: {name: 'Military School'}}
        put "/api/roles/unknown", params: params.to_json, headers: authorized_headers
        assert_response :not_found
        save_example "Update a non-existent role"
      end

      test "update role fails with invalid params" do
        params = {role: {name: 'Napolean'}}
        post '/api/roles', params: params.to_json, headers: authorized_headers
        id = response_body['role']['id']
        params = {role: {permissions: ["bowling"]}}
        put "/api/roles/#{id}", params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
        save_example "Update a role with invalid permissions"
      end

      test "delete role succeeds if role exists" do
        params = {role: {name: 'Chuck Denomolus'}}
        post '/api/roles/', params: params.to_json, headers: authorized_headers
        id = response_body['role']['id']
        delete "/api/roles/#{id}", headers: authorized_headers
        assert_response :no_content
        save_example "Delete a role"
      end

      test "delete role fails if role can't be found" do
        delete "/api/roles/every_rose", headers: authorized_headers
        assert_response :not_found
        save_example "Can't delete a non-existent role"
      end

      test "delete role fails with suitable error if role can't be removed" do
        delete "/api/roles/#{Role.first.uuid}", headers: authorized_headers
        assert_response :unprocessable_entity
        save_example "Admin roles cannot be removed"
      end

      test "view role users" do
        get "/api/roles/#{Role.first.uuid}/users", headers: authorized_headers
        assert_response :success
        assert_equal 1, response_body['users'].count
        user = Organization.first.users.first
        assert_equal user.uuid, response_body['users'][0]['id']
        save_example "Get role users"
      end

      test "add a new member to role" do
        role = Role.first
        user = User.all[2]
        assert_equal 1, role.users.count
        put "/api/roles/#{role.uuid}/users/#{user.uuid}", headers: authorized_headers
        assert_response :no_content
        assert_equal 2, role.users.count
        save_example "Add new member to role"
      end

      test "adding a new member is an idempotent action" do
        role = Role.first
        user = User.all[2]
        assert_equal 1, role.users.count
        2.times do
          put "/api/roles/#{role.uuid}/users/#{user.uuid}", headers: authorized_headers
          assert_response :no_content
          assert_equal 2, role.users.count
        end
      end

      test "add a non-existent user to role" do
        role = Role.first
        put "/api/roles/#{role.uuid}/users/station", headers: authorized_headers
        assert_response :not_found
        save_example "Add non-existent member to role"
      end

      test "remove member from a role" do
        role = Role.first
        user = User.all[2]
        put "/api/roles/#{role.uuid}/users/#{user.uuid}", headers: authorized_headers
        assert_response :no_content
        assert_equal 2, role.users.count
        delete "/api/roles/#{role.uuid}/users/#{user.uuid}", headers: authorized_headers
        assert_response :no_content
        assert_equal 1, role.users.count
        save_example "Remove member from role"
      end

      test "removing a member is an idempotent action" do
        role = Role.first
        user = User.all[2]
        put "/api/roles/#{role.uuid}/users/#{user.uuid}", headers: authorized_headers
        assert_response :no_content
        assert_equal 2, role.users.count
        2.times do
          delete "/api/roles/#{role.uuid}/users/#{user.uuid}", headers: authorized_headers
          assert_response :no_content
          assert_equal 1, role.users.count
        end
      end

      test "remove member from a non-existent role" do
        user = User.all[2]
        delete "/api/roles/psychoanalyst/users/#{user.uuid}", headers: authorized_headers
        assert_response :not_found
        save_example "Remove member from a non-existent role"
      end
    end
  end
end
