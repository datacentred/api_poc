require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class ProjectsUsersController < AuthorizedController

      def index
        respond_with users: serialized_users
      end

      def update
        head :no_content if project.users << user
      end

      def destroy
        head :no_content if project.users -= [user]
      end

      private

      def scoped_projects
        current_organization.projects
      end

      def scoped_users
        current_organization.users
      end

      def project
        project = scoped_projects.find_by(uuid: params[:project_id])
        raise ActionController::RoutingError.new('Not Found', ["No such project '#{params[:project_id]}'"]) unless project
        project
      end

      def user
        user = scoped_users.find_by(uuid: params[:id])
        raise ActionController::RoutingError.new('Not Found', ["No such user '#{params[:id]}'"]) unless user
        user
      end

      def serialized_users
        project.users.map do |u|
          Harbour::V1::UserSerializer.new(u).serialize
        end
      end

    end
  end
end
