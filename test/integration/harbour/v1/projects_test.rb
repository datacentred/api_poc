require 'test_helper'

module Harbour
  module V1
    class ProjectsTest < ApiTest
      def project_format
        {
          "uuid"       => String,
          "name"       => String,
          "links"      => Array,
          "users"      => Array
        }
      end

      test "api user must be authorized to access projects" do
        assert_resource_is_unauthorized "projects"
      end

      test "projects index has two projects" do
        get '/api/projects', headers: authorized_headers
        assert_response :success
        assert_equal 2, response_body['projects'].count
      end

      test "projects index projects belong to org1" do
        get '/api/projects', headers: authorized_headers
        names = response_body['projects'].map{|u| u['name']}
        assert names.include? "bogus"
        assert names.include? "excellent"
      end

      test "index project matches format" do
        get '/api/projects', headers: authorized_headers
        user = response_body['projects'][1]
        assert_format_matches project_format, user
      end

      test "can find project 1" do
        get '/api/projects/1', headers: authorized_headers
        assert_response :success
      end

      test "can't find project 3" do
        get '/api/projects/3', headers: authorized_headers
        assert_response :not_found
      end

      test "project 1 matches format" do
        get '/api/projects/1', headers: authorized_headers  
        assert_format_matches project_format, response_body['project']
      end

      test "create project succeeds with valid params" do
        params = {project: {name: 'wild_stalyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        assert_response :created
        assert_operator response_body['project']['uuid'].length, :>, 0
      end

      test "create project fails with invalid params" do
        params = {project: {name: 'wild_stalyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        post '/api/projects', params: params.to_json, headers: authorized_headers
        assert_response :unprocessable_entity
        assert_operator response_body['errors'].length, :>, 0
        assert_equal "project", response_body['errors'][0]["resource"]
        assert_equal "name",    response_body['errors'][0]["field"]
      end

      test "create project with user memberships" do
        skip
      end

      test "update project succeeds with valid params" do
        params = {project: {name: 'wild_stalyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        uuid = response_body['project']['uuid']
        params = {project: {name: 'wild_stalyns_rock'}}
        put "/api/projects/#{uuid}", params: params.to_json, headers: authorized_headers
        assert_response :ok
        assert_equal 'wild_stalyns_rock', response_body['project']['name']
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
      end

      test "update project with user memberships" do
        skip
      end

      test "delete project succeeds if project exists" do
        params = {project: {name: 'wild_stalyns'}}
        post '/api/projects', params: params.to_json, headers: authorized_headers
        uuid = response_body['project']['uuid']
        delete "/api/projects/#{uuid}", headers: authorized_headers
        assert_response :no_content
      end

      test "delete project fails if project can't be found" do
        delete "/api/projects/notarealproject", headers: authorized_headers
        assert_response :not_found
      end

      test "delete project fails with suitable error if project can't be removed" do
        # e.g. if it's the primary project
      end
    end
  end
end
