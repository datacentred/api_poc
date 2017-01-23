require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class UsersController < AuthorizedController
      include UsersDoc

      def create
        user = current_organization.users.create!(create_params)
        respond_with({user: Harbour::V1::UserDecorator.new(user).as_json},
                     status: :created)
      end

      def index
        respond_with users: decorated_users
      end

      def update
        user.update!(update_params)
        respond_with user: user
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

      def decorated_users
        scoped_users.map do |u|
          Harbour::V1::UserDecorator.new(u).as_json
        end
      end

      def create_params
        params.require(:user).permit(:email, :first_name, :last_name, :password, :projects)
      end

      def update_params
        params.require(:user).permit(:first_name, :last_name, :password, :projects)
      end

      def set_project_memberships(user_uuid, project_uuids)
        project_ids = project_uuids.map{|uuid| Project.find_by(uuid)&.id }.compact
        user_id     = scoped_users.find_by(uuid: user_uuid).id
        project_ids.each do |project_id|
          UserProjectRole.required_role_ids.collect do |role_uuid|
            UserProjectRole.find_or_create_by(user_id: user_id, project_id: @project.id, role_uuid: role_uuid)
          end
        end
      end
    end
  end
end