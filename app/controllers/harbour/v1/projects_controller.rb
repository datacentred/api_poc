require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class ProjectsController < AuthorizedController
      include ProjectsDoc

      def create
        project = current_organization.projects.create!(create_or_update_params)
        #set_project_memberships(user.id, create_params[:projects]) if create_params[:projects]&.any?
        respond_with({project: Harbour::V1::ProjectDecorator.new(project.reload).as_json},
                     status: :created)
      end

      def index
        respond_with projects: decorated_projects
      end

      def update
        project.update!(create_or_update_params)
        respond_with project: project
      end

      def show
        respond_with project: project
      end

      def destroy
        head :no_content if project.destroy
      end

      private

      def project
        project = scoped_projects.find_by(uuid: params[:id])
        raise ActionController::RoutingError.new('Not Found') unless project
        Harbour::V1::ProjectDecorator.new(project)
      end

      def decorated_projects
        scoped_projects.map do |p|
          Harbour::V1::ProjectDecorator.new(p).as_json
        end
      end

      def create_or_update_params
        params.require(:project).permit(:name, :users)
      end
    end
  end
end