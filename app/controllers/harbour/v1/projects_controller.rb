require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class ProjectsController < AuthorizedController
      include ProjectsDoc

      def create
        respond_with 'message': 'created'
      end

      def index
        respond_with projects: decorated_projects
      end

      def update
        respond_with({'message': 'updated'})
      end

      def show
        if project
          respond_with project: project
        else
          head :not_found
        end
      end

      def destroy
        if project.destroy
          head :no_content
        else
          head :not_found
        end
      end

      private

      def project
        project = scoped_projects.find_by(uuid: params[:id])
        Harbour::V1::ProjectDecorator.new(project) if project
      end

      def scoped_projects
        Project.where(organization: current_organization).includes(:users)
      end

      def decorated_projects
        scoped_projects.map do |p|
          Harbour::V1::ProjectDecorator.new(p).as_json
        end
      end
    end
  end
end