module Harbour
  module V1
    module ProjectsDoc
      def self.superclass
        Harbour::V1::ProjectsController
      end
      extend Apipie::DSL::Concern
      extend Harbour::Utils

      resource_description do
        resource_id 'Projects'
        api_versions 'v1'
      end

      def_param_group :project do
        param   :project, Hash,   desc: 'Project information', required: true, action_aware: true do
          param :name,    String, desc: 'Name of the project', required: true, as: :create
        end
      end

      api :POST, '/projects', 'Create a new project'
      description 'Create a new DataCentred cloud project (backed by OpenStack).'
      param_group :project, as: :create
      error 201, "Created successfully."
      error 422, "Failed validation. Details of failure returned in body."
      examples 'create'
      def create ; end

      api :GET, '/projects', 'List all available projects'
      description "Show a list of all the projects."
      error 200, "Success"
      examples 'index'
      def index ; end

      api :GET, '/projects/:id', 'Show a project'
      description 'Show the specified project'
      param :id, String, desc: 'The unique identifier for this project', required: true
      error 200, "Success"
      error 404, "Project couldn't be found"
      examples 'show'
      def show ; end

      api :PUT, '/projects/:id', 'Update a project'
      description 'Update the specified project'
      param :id, String, desc: 'The unique identifier for this project', required: true
      param_group :project, as: :name
      error 200, "Updated project successfully"
      error 404, "Project couldn't be found"
      error 422, "Failed validation. Details of failure returned in body."
      examples 'update'
      def update ; end

      api :DELETE, '/projects/:id', 'Delete a project'
      description 'Permanently remove the specified project.'
      param :id, String, desc: 'The unique identifier for this project', required: true
      error 204, "Removed project successfully"
      error 404, "Project couldn't be found"
      error 422, "Couldn't delete project. Details of failure returned in body."
      examples 'destroy'
      def destroy ; end
    end
  end
end
