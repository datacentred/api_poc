require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class UsersController < AuthorizedController
      include UsersDoc

      def create
        user = current_organization.users.create!(create_params)
        respond_with(Harbour::V1::UserDecorator.new(user).as_json, status: :created)
      end

      def index
        respond_with users: decorated_users
      end

      def update
        respond_with 'message': 'updated'
      end

      def show
        if user
          respond_with user: user
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

      def create_params
        params.require(:user).permit(:email, :first_name, :last_name, :password, :projects)
      end
    end
  end
end