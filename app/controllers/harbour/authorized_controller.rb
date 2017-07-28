require_dependency "harbour/application_controller"

module Harbour
  class AuthorizedController < ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :api_credential, :set_authorization

    def api_credential
      @api_credential ||= authenticate_with_http_token do |token, _|
        access, secret = token.split(':')
        credential = ApiCredential.enabled.find_by_access_key(access)
        credential&.authenticate_and_authorize(secret) ? credential : nil
      end
      @api_credential || render_unauthorized
    end

    def current_user
      current_organization_user&.user
    end

    def current_organization
      current_organization_user&.organization
    end

    def current_organization_user
      api_credential&.organization_user
    end

    def set_authorization
      Authorization.current_user              = current_user
      Authorization.current_organization      = current_organization
      Authorization.current_organization_user = current_organization_user
    end

    def render_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="DataCentred"'
      render_error(
        :unauthorized,
        [
          {
            detail: "Token authentication failed. Invalid credentials or API access is not authorized."
          }
        ]
      )
    end
  end
end
