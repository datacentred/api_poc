require_dependency "harbour/application_controller"

module Harbour
  module V1
    class SchemasController < ApplicationController
      include Harbour::Utils

      def show
        respond_with schema: schema
      end

      private

      def schema
        schema = json_schema(self, params[:id])
        raise ActionController::RoutingError.new('Not Found') unless schema
        schema
      end
    end
  end
end
