require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class UsersController < AuthorizedController
      include UsersDoc

      def create
        user = current_organization.users.create!(create_params)
        #set_project_memberships(user.id, create_params[:projects]) if create_params[:projects]&.any?
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
          respond_with({message: "You can't delete yourself."},
                       status: :unprocessable_entity)
        else
          user.destroy
          head :no_content
        end
      end

      private

      def user
        user = scoped_users.find_by(uuid: params[:id])
        raise ActionController::RoutingError.new('Not Found') unless user
        user
      end

      def serialized_users
        scoped_users.map do |u|
          Harbour::V1::UserSerializer.new(u).serialize
        end
      end

      def create_params
        params.require(:user).permit(:email, :first_name, :last_name, :password, :projects)
      end

      def update_params
        params.require(:user).permit(:first_name, :last_name, :password, :projects)
      end

      def set_project_memberships(user_id, project_uuids)
        project_ids = project_uuids.map{|uuid| scoped_projects.find_by(uuid)&.id }.compact
        project_ids.each do |project_id|
          UserProjectRole.required_role_ids.collect do |role_uuid|
            UserProjectRole.find_or_create_by(user_id: user_id, project_id: project_id, role_uuid: role_uuid)
          end
        end
      end
    end
  end
end