require_dependency "harbour/application_controller"

module Harbour
  class AuthorizedController < ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :set_api_version_header, :current_user

    def authenticate_token
      authenticate_with_http_token do |token, _|
        access, secret = token.split(':')
        api_credential = ApiCredential.find_by_access_key(access)
        api_credential&.authenticate(secret) ? api_credential.user : false
      end
    end

    def current_user
      authenticate_token || render_unauthorized
    end

    def render_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="DataCentred"'
      render json: {error: "Token authentication failed"}, status: 401
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

    private

    def set_api_version_header
      version = request.headers.fetch(:accept)&.scan(/version=(\d+)/)&.first&.first
      if version
        unless Harbour::Engine.config.api_versions.include?("V#{version}".to_sym)
          render json: {
            error: "Unknown API version #{version}.",
            links: [
              {href: Harbour::Engine.config.public_url, rel: 'help'}
            ] 
          }, status: 406
        end
      else
        version = Harbour::Engine.config.latest_api_version.to_s.scan(/V(\d+)/).first.first
      end
      response.headers['X-API-Version'] = version
    end
  end
end
