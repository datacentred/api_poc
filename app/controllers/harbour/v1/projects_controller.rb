require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class ProjectsController < AuthorizedController
      include ProjectsDoc

      def create
        respond_with({'message': 'created'})
      end

      def index
        respond_with(Project.all.includes(:users))
      end

      def update
        respond_with({'message': 'updated'})
      end

      def show
        respond_with({'foo': 'bar'})
      end

      def destroy
        respond_with({'message': 'destroyed'})
      end
    end
  end
end