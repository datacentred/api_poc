module Harbour
  module V1
    module ProjectsDoc
      extend CurlHelper

      def self.superclass
        V1::ProjectsController
      end
      extend Apipie::DSL::Concern

      resource_description do
        resource_id 'Projects'
        api_versions 'v1'
      end

      def_param_group :project do
        param :project, Hash, desc: 'Project information', required: true do
          param :name, String, desc: 'Name of the project', required: true
        end
      end

      api :POST, '/projects', 'Create project'
      description 'Create project with specifed project params'
      param_group :project
      
      example <<-EOS
    #{curl_method('projects', '1', {'X': 'POST', 'd': '{"project": {"foo": "bar"}}'})}
      EOS
      def create ; end

      api :GET, '/projects', 'List projects'
      description <<-EOS
        Foo
      EOS
      example <<-EOS
    #{curl_method('projects','1') }
    [
      {
        "full_name": "Foo",
        "age": 25
      }
    ]
      EOS
      def index ; end

      api :PUT, '/projects/:uuid', 'Update project'
      description 'Update specified project information'
      param :uuid, String, required: true
      param_group :project
      error 404, "Missing"
      example <<-EOS
    #{curl_method('projects/1', '1', {'X': 'PUT', 'd': '{"project": {"foo": "bar"}}'})}
      EOS
      def update ; end

      api :GET, '/projects/:uuid', 'Get project'
      description 'Retrieve specified project information'
      param :uuid, String, required: true
      example <<-EOS
    #{curl_method('projects/1', '1')}
      EOS
      def show ; end

      api :DELETE, '/projects/:uuid', 'Delete project'
      description 'Remove specified project'
      param :uuid, String, required: true
      example <<-EOS
    #{curl_method('projects/1', '1', {'X': 'DELETE'})}
      EOS
      def destroy ; end
    end
  end
end
