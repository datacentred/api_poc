class AuthorizedController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :validate_credentials

  private

  def validate_credentials
    authenticate_or_request_with_http_token do |token, _|
      access, secret = token.split(':')
      User.find_by_access_key(access)&.authenticate(secret)
    end
  end
end