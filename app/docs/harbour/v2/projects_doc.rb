module Harbour
  module V2
    module ProjectsDoc
      def self.superclass
        Harbour::V2::ProjectsController
      end
      extend Apipie::DSL::Concern
      extend Harbour::Utils
      extend V1::ProjectsDoc

      resource_description do
        resource_id 'Projects'
        api_versions 'v1'
      end

      api :GET, '/projects', 'Narf narf'
      description "Narf"
      error 418, "I'm a teapot"
      def index ; end
    
    end
  end
end
