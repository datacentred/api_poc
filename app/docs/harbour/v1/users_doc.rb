module Harbour
  module V1
    module UsersDoc
      def self.superclass
        Harbour::V1::UsersController
      end
      extend Apipie::DSL::Concern
      extend Harbour::Utils

      resource_description do
        resource_id 'Users'
        api_versions 'v1'
      end

      def_param_group :user do
        param   :user,       Hash,   desc: 'User information',     required: true, action_aware: true do
          param :email,      String, desc: "User's email address", required: true, as: :create
          param :password,   String, desc: "User's password",      required: true, as: :create
          param :first_name, String, desc: "User's first name"
          param :last_name,  String, desc: "User's last name"
        end
      end

      api :POST, '/users', 'Create a new user'
      description 'Create a new DataCentred user (backed by OpenStack).'
      param_group :user, as: :create
      error code: 201, desc: "Created successfully."
      error code: 422, desc: "Failed validation. Details of failure returned in body."
      examples 'create'
      def create ; end

      api :GET, '/users', 'List all available users'
      description "Show a list of all the users"
      error 200, "Success"
      examples 'index'
      def index ; end

      api :GET, '/users/:id', 'Show a user'
      description 'Show the specified user'
      param :id, String, desc: 'The unique identifier for this user', required: true
      error 200, "Success"
      error 404, "User couldn't be found"
      examples 'show'
      def show ; end

      api :PUT, '/users/:id', 'Update a user'
      description 'Update the specified user'
      param :id, String, desc: 'The unique identifier for this user', required: true
      param_group :user, as: :update
      error 200, "Updated user successfully"
      error 404, "User couldn't be found"
      error 422, "Failed validation. Details of failure returned in body."
      examples 'update'
      def update ; end

      api :DELETE, '/users/:id', 'Delete a user'
      description 'Permanently remove the specified user.'
      param :id, String, desc: 'The unique identifier for this user', required: true
      error 204, "Removed project successfully"
      error 404, "Project id couldn't be found"
      error 422, "Couldn't delete user. Details of failure returned in body."
      examples 'destroy'
      def destroy ; end
    end
  end
end
