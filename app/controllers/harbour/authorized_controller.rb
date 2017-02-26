require_dependency "harbour/application_controller"

module Harbour
  class AuthorizedController < ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :current_user

    def authenticate_token
      authenticate_with_http_token do |token, _|
        access, secret = token.split(':')
        api_credential = ApiCredential.find_by_access_key(access)
        api_credential&.authenticate_and_authorize(secret) ? api_credential.user : false
      end
    end

    def current_user
      authenticate_token || render_unauthorized
    end

    def render_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="DataCentred"'
      render json: {error: "Token authentication failed. Invalid credentials or API access is not authorized."}, status: 401
    end

    def current_organization
      @current_organization ||= current_user.organization
    end

    def scoped_users
      User.where(organization: current_organization).includes(:projects)
    end

    def scoped_projects
      Project.where(organization: current_organization).includes(:users)
    end
  end
end
