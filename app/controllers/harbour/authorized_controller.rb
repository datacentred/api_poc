require_dependency "harbour/application_controller"

module Harbour
  class AuthorizedController < ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :current_user

    def current_user
      authenticate_or_request_with_http_token do |token, _|
        access, secret = token.split(':')
        api_credential = ApiCredential.find_by_access_key(access)
        api_credential&.authenticate(secret) ? api_credential.user : false
      end
    end

    def current_organization
      @current_organization ||= current_user.organization
    end
  end
end
