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
        uuid = response_body['projects'][0]['uuid']
        get "/api/projects/#{uuid}", headers: authorized_headers
        assert_response :success
        save_example "Show project #{uuid}"
      end

      test "can't find project 3" do
        get '/api/projects/not_found', headers: authorized_headers
        assert_response :not_found
        save_example "Can't find non-existent project"
      end

      test "project 1 matches format" do
        get '/api/projects', headers: authorized_headers
        uuid = response_body['projects'][1]['uuid']
        get "/api/projects/#{uuid}", headers: authorized_headers 
        project = response_body['project']
        JSON::Validator.validate!(schema(1, "project"), project)
      end

      test "create project succeeds with valid params" do
        params = {project: {name: 'wild_stalyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        assert_response :created
        assert_operator response_body['project']['uuid'].length, :>, 0
        save_example "Create a new project"
      end

      test "create project fails with invalid params" do
        params = {project: {name: 'wild_stalyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        post '/api/projects', params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
        assert_operator response_body['errors'].length, :>, 0
        assert_equal "project", response_body['errors'][0]["resource"]
        assert_equal "name",    response_body['errors'][0]["field"]
        save_example "Create a new project with a name that's taken already"
      end

      test "update project succeeds with valid params" do
        params = {project: {name: 'wild_stalyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        uuid = response_body['project']['uuid']
        params = {project: {name: 'wild_stalyns_rock'}}
        put "/api/projects/#{uuid}", params: params.to_json, headers: authorized_headers
        assert_response :ok
        assert_equal 'wild_stalyns_rock', response_body['project']['name']
        save_example "Update project #{uuid} with a new name"
      end

      test "update project fails with invalid params" do
        params = {project: {name: 'wild_stalyns_rock'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        params = {project: {name: 'wild_stalyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        uuid = response_body['project']['uuid']
        params = {project: {name: 'wild_stalyns_rock'}}
        put "/api/projects/#{uuid}", params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
        assert_equal "project", response_body['errors'][0]["resource"]
        assert_equal "name",    response_body['errors'][0]["field"]
        save_example "Update project #{uuid} with a name that's already taken"
      end

      test "update unknown project fails" do
        params = {project: {name: 'wild_stalyns_rock'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        params = {project: {name: 'wild_stalyns'}}
        put "/api/projects/unknown", params: params.to_json, headers: authorized_headers
        assert_response :not_found
        save_example "Update a non-existent project"
      end

      test "delete project succeeds if project exists" do
        params = {project: {name: 'wild_stalyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        uuid = response_body['project']['uuid']
        delete "/api/projects/#{uuid}", headers: authorized_headers
        assert_response :no_content
        save_example "Delete a project"
      end

      test "delete project fails if project can't be found" do
        delete "/api/projects/notarealproject", headers: authorized_headers
        assert_response :not_found
        save_example "Can't delete a non-existent project"
      end
    end
  end
end
