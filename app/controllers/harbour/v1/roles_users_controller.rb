require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class RolesUsersController < AuthorizedController

      def index
        respond_with users: serialized_users
      end

      def update
        unless role.organization_users.include? organization_user
          role.organization_users << organization_user
        end
        head :no_content 
      end

      def destroy
        if role.organization_users.include? organization_user
          role.organization_users -= [organization_user]
        end
        head :no_content
      end

      private

      def scoped_roles
        current_organization.roles
      end

      def scoped_users
        current_organization.users
      end

      def scoped_organization_users
        current_organization.organization_users
      end

      def role
        role = scoped_roles.find_by(uuid: params[:role_id])
        raise ActionController::RoutingError.new('Not Found', ["No such role '#{params[:role_id]}'"]) unless role
        role
      end

      def user
        user = scoped_users.find_by(uuid: params[:id])
        raise ActionController::RoutingError.new('Not Found', ["No such user '#{params[:id]}'"]) unless user
        user
      end

      def organization_user
        organization_user = scoped_organization_users.find_by(user: user)
        raise ActionController::RoutingError.new('Not Found', ["No such user '#{params[:id]}'"]) unless organization_user
        organization_user
      end

      def serialized_users
        role.users.map do |u|
          Harbour::V1::UserSerializer.new(u).serialize
        end
      end

    end
  end
end
