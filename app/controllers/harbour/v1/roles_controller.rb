require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class RolesController < AuthorizedController
      include RolesDoc

      def create
        role = current_organization.roles.create!(create_or_update_params)
        respond_with({role: Harbour::V1::RoleSerializer.new(role.reload).serialize},
                     status: :created)
      end

      def index
        respond_with roles: serialized_roles
      end

      def update
        role.update!(create_or_update_params)
        respond_with role: Harbour::V1::RoleSerializer.new(role).serialize
      end

      def show
        respond_with role: Harbour::V1::RoleSerializer.new(role).serialize
      end

      def destroy
        head :no_content if role.destroy!
      end

      private

      def scoped_roles
        current_organization.roles
      end

      def role
        role = scoped_roles.find_by(uuid: params[:id])
        raise ActionController::RoutingError.new('Not Found') unless role
        role
      end

      def serialized_roles
        scoped_roles.map do |r|
          Harbour::V1::RoleSerializer.new(r).serialize
        end
      end

      def create_or_update_params
        params.require(:role).permit(:name, :permissions => [])
      end
    end
  end
end
