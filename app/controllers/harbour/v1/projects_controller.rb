require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class ProjectsController < AuthorizedController
      include ProjectsDoc

      def create
        project = current_organization.projects.create!(create_or_update_params)
        respond_with({project: Harbour::V1::ProjectSerializer.new(project.reload).serialize},
                     status: :created)
      end

      def index
        respond_with projects: serialized_projects
      end

      def update
        project.update!(create_or_update_params)
        respond_with project: Harbour::V1::ProjectSerializer.new(project).serialize
      end

      def show
        respond_with project: Harbour::V1::ProjectSerializer.new(project).serialize
      end

      def destroy
        head :no_content if project.destroy
      end

      private

      def scoped_projects
        current_organization.projects
      end

      def project
        project = scoped_projects.find_by(uuid: params[:id])
        raise ActionController::RoutingError.new('Not Found') unless project
        project
      end

      def serialized_projects
        scoped_projects.map do |p|
          Harbour::V1::ProjectSerializer.new(p).serialize
        end
      end

      def create_or_update_params
        params.require(:project).permit(
          :name,
          :quota_set => {
            :compute => StartingQuota['standard']['compute'].keys.map(&:to_sym),
            :volume  => StartingQuota['standard']['volume'].keys.map(&:to_sym),
            :network => StartingQuota['standard']['network'].keys.map(&:to_sym)
          }
        )
      end
    end
  end
end