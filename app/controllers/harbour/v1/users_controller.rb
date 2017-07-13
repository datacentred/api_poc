require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class UsersController < AuthorizedController
      include UsersDoc

      def create
        user = current_organization.users.create!(create_params)
        respond_with({user: Harbour::V1::UserSerializer.new(user.reload).serialize},
                     status: :created)
      end

      def index
        respond_with users: serialized_users
      end

      def update
        user.update!(update_params)
        respond_with user: Harbour::V1::UserSerializer.new(user).serialize
      end

      def show
        respond_with user: Harbour::V1::UserSerializer.new(user).serialize
      end

      def destroy
        if user.id == current_user.id
          render_error(
            :unprocessable_entity,
            [
              {
                detail: "You can't delete yourself.",
                resource: "user"
              }
            ]
          )
        else
          organization_user.destroy
          head :no_content
        end
      end

      private

      def scoped_users
        current_organization.users
      end

      def user
        user = scoped_users.find_by(uuid: params[:id])
        raise ActionController::RoutingError.new('Not Found') unless user
        user
      end

      def organization_user
        user = scoped_users.find_by(uuid: params[:id])
        raise ActionController::RoutingError.new('Not Found') unless user
        organization_user = OrganizationUser.find_by(organization: current_organization, user: user)
        raise ActionController::RoutingError.new('Not Found') unless organization_user
        organization_user
      end

      def serialized_users
        scoped_users.map do |u|
          Harbour::V1::UserSerializer.new(u).serialize
        end
      end

      def create_params
        params.require(:user).permit(:email, :first_name, :last_name, :password)
      end

      def update_params
        params.require(:user).permit(:first_name, :last_name, :password)
      end
    end
  end
end