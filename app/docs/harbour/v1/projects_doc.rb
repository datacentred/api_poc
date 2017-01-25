module Harbour
  module V1
    module ProjectsDoc
      extend CurlHelper

      def self.superclass
        Harbour::V1::ProjectsController
      end
      extend Apipie::DSL::Concern

      resource_description do
        resource_id 'Projects'
        api_versions 'v1'
      end

      def_param_group :project do
        param :project, Hash, desc: 'Project information', required: true, :action_aware => true do
          param :name, String, desc: 'Name of the project', required: true, as: :create
        end
      end

      api :POST, '/projects', 'Create a new project'
      description 'Create a new DataCentred cloud project (backed by OpenStack).'
      param_group :project, as: :create
      error 201, "Created successfully"
      error 422, "Failed validation. Details of failure returned in body."
      
      example <<-EOS
# Create new project
#{curl_method('projects', '1', {'X': 'POST', 'd': '{"project": {"name": "wyld_stalyns"}}'})}
{
  "project":{
    "uuid":"24c1de959cb943e0bf11e5ca6c8f8ad8",
    "name":"wyld_stalyns",
    "links":[
      {
        "href":"#{Harbour::Engine.config.public_url}/projects/24c1de959cb943e0bf11e5ca6c8f8ad8",
        "rel":"self"
      }
    ],
    "users":[]
  }
}
EOS
example <<-EOS
# Create new project when name is already taken
#{curl_method('projects', '1', {'X': 'POST', 'd': '{"project": {"name": "already_taken"}}'})}
{
  "errors":[
    {
      "resource": "project",
      "field": "name",
      "detail": "Project name is already in use."
    }
  ]
}
EOS
      def create ; end

      api :GET, '/projects', 'List all available projects'
      description "Show a list of all the projects."
      error 200, "Success"
      example <<-EOS
# List all available projects
#{curl_method('projects','1') }
{
  "projects":[
    {
      "uuid": "24c1de959cb943e0bf11e5ca6c8f8ad8",
      "name": "wyld_stalyns",
      "links":[
        {
          "href": "http://localhost:3000/api/projects/24c1de959cb943e0bf11e5ca6c8f8ad8",
          "rel": "self"
        }
      ],
      "users":[]
    }
  ]
}
      EOS
      def index ; end

      api :GET, '/projects/:uuid', 'Show project'
      description 'Show specified project'
      param :uuid, String, desc: 'The unique identifier for this project', required: true
      error 200, "Success"
      error 404, "Project UUID couldn't be found"
      example <<-EOS
# Show specified project
#{curl_method('projects/24c1de959cb943e0bf11e5ca6c8f8ad8', '1')}
{
  "project":{
    "uuid": "24c1de959cb943e0bf11e5ca6c8f8ad8",
    "name": "wyld_stalyns",
    "links":[
      {
        "href": "http://localhost:3000/api/projects/24c1de959cb943e0bf11e5ca6c8f8ad8",
        "rel": "self"
      }
    ],
    "users":[]
  }
}
      EOS
      def show ; end

      api :PUT, '/projects/:uuid', 'Update a project'
      description 'Update specified project params'
      param :uuid, String, desc: 'The unique identifier for this project', required: true
      param_group :project, as: :name
      error 200, "Updated project successfully"
      error 404, "Project UUID couldn't be found"
      error 422, "Failed validation. Details of failure returned in body."
      example <<-EOS
# Rename project
#{curl_method('projects/24c1de959cb943e0bf11e5ca6c8f8ad8', '1', {'X': 'PUT', 'd': '{"project": {"name": "wyld_stalyns_rock"}}'})}
{
  "project":{
    "uuid": "24c1de959cb943e0bf11e5ca6c8f8ad8",
    "name": "wyld_stalyns_rock",
    "links":[
      {
        "href": "http://localhost:3000/api/projects/24c1de959cb943e0bf11e5ca6c8f8ad8",
        "rel": "self"
      }
    ],
    "users":[]
  }
}
      EOS
      def update ; end

      api :DELETE, '/projects/:uuid', 'Delete project'
      description 'Permanently removes the specified project.'
      param :uuid, nil, desc: 'The unique identifier for this project', required: true
      error 204, "Removed project successfully"
      error 404, "Project UUID couldn't be found"
      error 422, "Couldn't delete project. Details of failure returned in body."
      example <<-EOS
# Delete project
#{curl_method('projects/24c1de959cb943e0bf11e5ca6c8f8ad8', '1', {'X': 'DELETE', 'I': nil})}
HTTP/1.1 204 No Content
      EOS
      def destroy ; end
    end
  end
end
