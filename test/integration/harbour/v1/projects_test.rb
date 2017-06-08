require 'test_helper'

module Harbour
  module V1
    class ProjectsTest < ApiTest
      test "api user must be authorized to access projects" do
        assert_resource_is_unauthorized "projects"
      end

      test "projects index has two projects" do
        get '/api/projects', headers: authorized_headers
        assert_response :success
        assert_equal 2, response_body['projects'].count
        save_example "Get projects index"
      end

      test "projects index projects belong to org1" do
        get '/api/projects', headers: authorized_headers
        names = response_body['projects'].map{|u| u['name']}
        assert names.include? "bogus"
        assert names.include? "excellent"
      end

      test "index project matches format" do
        get '/api/projects', headers: authorized_headers
        project = response_body['projects'][1]
        JSON::Validator.validate!(schema(1, "project"), project)
      end

      test "can find project 1" do
        get '/api/projects', headers: authorized_headers
        id = response_body['projects'][0]['id']
        get "/api/projects/#{id}", headers: authorized_headers
        assert_response :success
        save_example "Show project #{id}"
      end

      test "can't find project 3" do
        get '/api/projects/not_found', headers: authorized_headers
        assert_response :not_found
        save_example "Can't find non-existent project"
      end

      test "project 1 matches format" do
        get '/api/projects', headers: authorized_headers
        id = response_body['projects'][1]['id']
        get "/api/projects/#{id}", headers: authorized_headers 
        project = response_body['project']
        JSON::Validator.validate!(schema(1, "project"), project)
      end

      test "create project succeeds with valid params" do
        params = {project: {name: 'wyld_stallyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        assert_response :created
        assert_operator response_body['project']['id'].length, :>, 0
        save_example "Create a new project"
      end

      test "create project fails with invalid params" do
        params = {project: {name: 'wyld_stallyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        post '/api/projects', params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
        assert_operator response_body['errors'].length, :>, 0
        assert_equal "project", response_body['errors'][0]["resource"]
        assert_equal "name",    response_body['errors'][0]["field"]
        save_example "Create a new project with a name that's taken already"
      end

      test "create project fails with invalid quota params" do
        params = {project: {name: 'wyld_stallyns', quota_set: {"compute": {"ram": "boom"}}}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
        assert_operator response_body['errors'].length, :>, 0
        assert_equal "project",   response_body['errors'][0]["resource"]
        assert_equal "quota_set", response_body['errors'][0]["field"]
      end

      test "update project succeeds with valid params" do
        params = {project: {name: 'wyld_stallyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        id = response_body['project']['id']
        params = {project: {quota_set: {compute: {cores: 5}}}}
        put "/api/projects/#{id}", params: params.to_json, headers: authorized_headers
        assert_response :ok
        assert_equal 5, response_body['project']['quota_set']['compute']['cores']
        save_example "Update project #{id} with new compute cores quota"
      end

      test "update project fails with invalid params" do
        params = {project: {name: 'wyld_stallyns_rock'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        params = {project: {name: 'wyld_stallyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        id = response_body['project']['id']
        params = {project: {name: 'wyld_stallyns_rock'}}
        put "/api/projects/#{id}", params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
        assert_equal "project", response_body['errors'][0]["resource"]
        assert_equal "name",    response_body['errors'][0]["field"]
        save_example "Update project #{id} with a name that's already taken"
      end

      test "update project fails with invalid quota params" do
        params = {project: {name: 'wyld_stallyns_rock'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        id = response_body['project']['id']
        params = {project: {quota_set: {"compute": {"ram": "boom"}}}}
        put "/api/projects/#{id}", params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
        assert_equal "project",   response_body['errors'][0]["resource"]
        assert_equal "quota_set", response_body['errors'][0]["field"]
      end

      test "update unknown project fails" do
        params = {project: {name: 'wyld_stallyns_rock'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        params = {project: {name: 'wyld_stallyns'}}
        put "/api/projects/unknown", params: params.to_json, headers: authorized_headers
        assert_response :not_found
        save_example "Update a non-existent project"
      end

      test "delete project succeeds if project exists" do
        params = {project: {name: 'wyld_stallyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        id = response_body['project']['id']
        delete "/api/projects/#{id}", headers: authorized_headers
        assert_response :no_content
        save_example "Delete a project"
      end

      test "delete project fails if project can't be found" do
        delete "/api/projects/military_school", headers: authorized_headers
        assert_response :not_found
        save_example "Can't delete a non-existent project"
      end

      test "view project users" do
        get "/api/projects/#{Project.first.uuid}/users", headers: authorized_headers
        assert_response :success
        assert_equal 1, response_body['users'].count
        user = Organization.first.users.first
        assert_equal user.uuid, response_body['users'][0]['id']
        save_example "Get project users"
      end

      test "add a new member to project" do
        project = Project.first
        user = User.all[2]
        assert_equal 1, project.users.count
        put "/api/projects/#{project.uuid}/users/#{user.uuid}", headers: authorized_headers
        assert_response :no_content
        assert_equal 2, project.users.count
        save_example "Add new member to project"
      end

      test "adding a new member to a project is an idempotent action" do
        project = Project.first
        user = User.all[2]
        assert_equal 1, project.users.count
        2.times do
          put "/api/projects/#{project.uuid}/users/#{user.uuid}", headers: authorized_headers
          assert_response :no_content
          assert_equal 2, project.users.count
        end
      end

      test "add a non-existent user to project" do
        project = Project.first
        put "/api/projects/#{project.uuid}/users/station", headers: authorized_headers
        assert_response :not_found
        save_example "Add non-existent member to project"
      end

      test "remove member from a project" do
        project = Project.first
        user = User.all[2]
        put "/api/projects/#{project.uuid}/users/#{user.uuid}", headers: authorized_headers
        assert_response :no_content
        assert_equal 2, project.users.count
        delete "/api/projects/#{project.uuid}/users/#{user.uuid}", headers: authorized_headers
        assert_response :no_content
        assert_equal 1, project.users.count
        save_example "Remove member from project"
      end

      test "removing a member from a project is an idempotent action" do
        project = Project.first
        user = User.all[2]
        put "/api/projects/#{project.uuid}/users/#{user.uuid}", headers: authorized_headers
        assert_response :no_content
        assert_equal 2, project.users.count
        2.times do
          delete "/api/projects/#{project.uuid}/users/#{user.uuid}", headers: authorized_headers
          assert_response :no_content
          assert_equal 1, project.users.count
        end
      end

      test "remove member from a non-existent project" do
        user = User.all[2]
        delete "/api/projects/psychoanalysts/users/#{user.uuid}", headers: authorized_headers
        assert_response :not_found
        save_example "Remove member from a non-existent project"
      end
    end
  end
end
