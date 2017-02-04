require_dependency "harbour/authorized_controller"

module Harbour
  module V2
    class ProjectsController < V1::ProjectsController
      include ProjectsDoc

      def index
        render text: 'foo'
      end
    end
  end
end