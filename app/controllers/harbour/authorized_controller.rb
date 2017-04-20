require_dependency "harbour/application_controller"

module Harbour
  class AuthorizedController < ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :current_user

    def authenticate_token
      authenticate_with_http_token do |token, _|
        access, secret = token.split(':')
        api_credential = ApiCredential.find_by_access_key(access)
        api_credential&.authenticate_and_authorize(secret) ? api_credential : nil
      end
    end

    def current_user
      authenticate_token&.user || render_unauthorized
    end

    def render_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="DataCentred"'
      render json: {error: "Token authentication failed. Invalid credentials or API access is not authorized."}, status: 401
    end

    def current_organization
      @current_organization ||= authenticate_token&.organization
    end
  end
end
