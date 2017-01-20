require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class UsersController < AuthorizedController
      include UsersDoc

      def create
        respond_with({'message': 'created'})
      end

      def index
        respond_with decorated_users
      end

      def update
        respond_with({'message': 'updated'})
      end

      def show
        if user
          respond_with user
        else
          head :not_found
        end
      end

      def destroy
        if user.destroy
          head :no_content
        else
          head :not_found
        end
      end

      private

      def user
        user = scoped_users.find_by(uuid: params[:id])
        Harbour::V1::UserDecorator.new(user) if user
      end

      def scoped_users
        User.where(organization: current_organization).includes(:projects)
      end

      def decorated_users
        scoped_users.map do |u|
          Harbour::V1::UserDecorator.new(u).as_json
        end
      end
    end
  end
end