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
        get '/api/projects', authorized_headers
        assert_response :success
        assert_equal 2, response_body['projects'].count
      end

      test "projects index projects belong to org1" do
        get '/api/projects', authorized_headers
        names = response_body['projects'].map{|u| u['name']}
        assert names.include? "bogus"
        assert names.include? "excellent"
      end

      test "index project matches format" do
        get '/api/projects', authorized_headers
        user = response_body['projects'][1]
        assert_format_matches project_format, user
      end

      test "can find project 1" do
        get '/api/projects/1', authorized_headers
        assert_response :success
      end

      test "can't find project 3" do
        get '/api/projects/3', authorized_headers
        assert_response :not_found
      end

      test "project 1 matches format" do
        get '/api/projects/1', authorized_headers  
        assert_format_matches project_format, response_body['project']
      end
    end
  end
end
