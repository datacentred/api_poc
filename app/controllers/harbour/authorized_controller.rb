require_dependency "harbour/application_controller"

module Harbour
  class AuthorizedController < ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :current_user

    def current_user
      # authenticate_or_request_with_http_token do |token, _|
      #   access, secret = token.split(':')
      #   Stronghold::ApiUser.find_by_access_key(access)&.authenticate(secret)
      # end
      @current_user ||= User.first
    end

    def current_organization
      @current_organization ||= current_user.organization
    end
  end
end
