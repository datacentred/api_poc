module Harbour
  module V1
    module UsersDoc
      extend CurlHelper

      def self.superclass
        Harbour::V1::UsersController
      end
      extend Apipie::DSL::Concern

      resource_description do
        resource_id 'Users'
        api_versions 'v1'
      end

      def_param_group :user do
        param :user, Hash, desc: 'User information', required: true do
          param :email, String, desc: "User's email address", required: true
          param :first_name, String, desc: "User's first name", required: false
          param :last_name,  String, desc: "User's last name", required: false
        end
      end

      api :POST, '/users', 'Create user'
      description 'Create user with specifed user params'
      param_group :user
      error code: 201, desc: "Created"
      error code: 422, desc: "Validation failed"
      example <<-EOS
#{curl_method('users', '1', {'X': 'POST', 'd': '{"user": {"email": "bill.s.preston@bogus.com", "first_name": "Bill S.", "last_name": "Preston Esq"}}'})}
      EOS
      def create ; end

      api :GET, '/users', 'List users'
      description <<-EOS
        Foo
      EOS
      example <<-EOS
    #{curl_method('users','1') }
    [
      {
        "full_name": "Foo",
        "age": 25
      }
    ]
      EOS
      def index ; end

      api :PUT, '/users/:uuid', 'Update user'
      description 'Update specified user information'
      param :uuid, String, required: true
      param_group :user
      error 404, "Missing"
      example <<-EOS
    #{curl_method('users/612bfb90f93c4b6e9ba515d51bb16022', '1', {'X': 'PUT', 'd': '{"user": {"foo": "bar"}}'})}
      EOS
      def update ; end

      api :GET, '/users/:uuid', 'Get user'
      description 'Retrieve specified user information'
      param :uuid, String, required: true
      example <<-EOS
    #{curl_method('users/612bfb90f93c4b6e9ba515d51bb16022', '1')}
      EOS
      def show ; end

      api :DELETE, '/users/:uuid', 'Delete user'
      description 'Remove specified user'
      param :uuid, String, required: true
      example <<-EOS
    #{curl_method('users/612bfb90f93c4b6e9ba515d51bb16022', '1', {'X': 'DELETE'})}
      EOS
      def destroy ; end
    end
  end
end
