module Harbour
  module V1
    module RolesDoc
      def self.superclass
        Harbour::V1::RolesController
      end
      extend Apipie::DSL::Concern
      extend Harbour::Utils

      resource_description do
        resource_id 'Roles'
        api_versions 'v1'
      end

      def_param_group :role do
        param :role, Hash,   desc: 'Role information', required: true, action_aware: true do
          param :name, String, desc: 'Name of the role', required: true, as: :create
          param :permissions, Array, of: String, desc: 'Role permissions', required: false
        end
      end

      api :POST, '/roles', 'Create a new role'
      description 'Create a new role for users.'
      param_group :role, as: :create
      error 201, "Created successfully."
      error 422, "Failed validation. Details of failure returned in body."
      examples 'create'
      def create ; end

      api :GET, '/roles', 'List all available roles'
      description "Show a list of all the roles."
      error 200, "Success"
      examples 'index'
      def index ; end

      api :GET, '/roles/:uuid', 'Show a role'
      description 'Show the specified role'
      param :uuid, String, desc: 'The unique identifier for this role', required: true
      error 200, "Success"
      error 404, "Role couldn't be found"
      examples 'show'
      def show ; end

      api :PUT, '/roles/:uuid', 'Update a role'
      description 'Update the specified role'
      param :uuid, String, desc: 'The unique identifier for this role', required: true
      param_group :role, as: :name
      error 200, "Updated role successfully"
      error 404, "Role couldn't be found"
      error 422, "Failed validation. Details of failure returned in body."
      examples 'update'
      def update ; end

      api :DELETE, '/roles/:uuid', 'Delete a role'
      description 'Permanently remove the specified role.'
      param :uuid, String, desc: 'The unique identifier for this role', required: true
      error 204, "Removed role successfully"
      error 404, "Role couldn't be found"
      error 422, "Couldn't delete role. Details of failure returned in body."
      examples 'destroy'
      def destroy ; end

      api :GET, '/roles/:uuid/users', 'List all members of this role'
      description "Show a list of all the members assigned to this role."
      error 200, "Success"
      examples 'index', "roles_users"
      def members ; end

      api :PUT, '/roles/:uuid/users/:uuid', 'Add new member to this role'
      description "Add a new member (user) to this role, giving them the associated permissions."
      error 200, "Success"
      error 404, "Role/user couldn't be found"
      examples 'update', "roles_users"
      def add ; end

      api :DELETE, '/roles/:uuid/users/:uuid', 'Remove member from this role'
      description "Remove member (user) from this role, revoking the associated permissions."
      error 200, "Success"
      error 404, "Role/user couldn't be found"
      examples 'destroy', "roles_users"
      def remove ; end
    end
  end
end
