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
        param   :user,       Hash,   desc: 'User information',     required: true, action_aware: true do
          param :email,      String, desc: "User's email address", required: true, as: :create
          param :password,   String, desc: "User's password",      required: true, as: :create
          param :first_name, String, desc: "User's first name"
          param :last_name,  String, desc: "User's last name"
        end
      end

      api :POST, '/users', 'Create a new user'
      description 'Create a new DataCentred user (backed by OpenStack).'
      param_group :user, as: :create
      error code: 201, desc: "Created successfully."
      error code: 422, desc: "Failed validation. Details of failure returned in body."
      example <<-EOS
# Createw new user
#{curl_method('users', '1', {'X': 'POST', 'd': '{"user": {"email": "bill.s.preston@bogus.com", "first_name": "Bill S.", "last_name": "Preston Esq", "password": "ilovejoanna"}}'})}
# =>
{
  "user":{
    "uuid": "4fd35cf93ff94a76ab206b11ae3d21e0",
    "email": "bill.s.preston@bogus.com",
    "first_name": "Bill S.",
    "last_name": "Preston",
    "links":[
      {
        "href": "http://localhost:3000/api/users/4fd35cf93ff94a76ab206b11ae3d21e0",
        "rel": "self"
      }
    ],
    "projects":[]
  }
}
      EOS
      def create ; end

      api :GET, '/users', 'List all available users'
      description "Show a list of all the users"
      error 200, "Success"
      example <<-EOS
#{curl_method('users','1')}
# =>
{
  "users":[
    {
      "uuid": "4fd35cf93ff94a76ab206b11ae3d21e0",
      "email": "bill.s.preston@bogus.com",
      "first_name": "Bill S.",
      "last_name": "Preston",
      "links":[
        {
          "href": "http://localhost:3000/api/users/4fd35cf93ff94a76ab206b11ae3d21e0",
          "rel": "self"
        }
      ],
      "projects":[]
    }
  ]
}
      EOS
      def index ; end

      api :GET, '/users/:uuid', 'Show user'
      description 'Show specified user'
      param :uuid, String, desc: 'The unique identifier for this user', required: true
      error 200, "Success"
      error 404, "User couldn't be found"
      example <<-EOS
# Show specified user
#{curl_method('users/4fd35cf93ff94a76ab206b11ae3d21e0', '1')}
# =>
{
  "user":{
    "uuid": "4fd35cf93ff94a76ab206b11ae3d21e0",
    "email": "bill.s.preston@bogus.com",
    "first_name": "Bill S.",
    "last_name": "Preston",
    "links":[
      {
        "href": "http://localhost:3000/api/users/4fd35cf93ff94a76ab206b11ae3d21e0",
        "rel": "self"
      }
    ],
    "projects":[]
  }
}
      EOS
      def show ; end

      api :PUT, '/users/:uuid', 'Update a user'
      description 'Update specified user'
      param :uuid, String, desc: 'The unique identifier for this user', required: true
      param_group :user, as: :update
      error 200, "Updated user successfully"
      error 404, "User couldn't be found"
      error 422, "Failed validation. Details of failure returned in body."
      example <<-EOS
# Rename user
#{curl_method('users/612bfb90f93c4b6e9ba515d51bb16022', '1', {'X': 'PUT', 'd': '{"user": {"last_name": "Preston Esq"}}'})}
# =>
{
  "user":{
    "uuid": "4fd35cf93ff94a76ab206b11ae3d21e0",
    "email": "bill.s.preston@bogus.com",
    "first_name": "Bill S.",
    "last_name": "Preston Esq",
    "links":[
      {
        "href": "http://localhost:3000/api/users/4fd35cf93ff94a76ab206b11ae3d21e0",
        "rel": "self"
      }
    ],
    "projects":[]
  }
}
      EOS
      def update ; end

      api :DELETE, '/users/:uuid', 'Delete user'
      description 'Permanently remove the specified user.'
      param :uuid, String, desc: 'The unique identifier for this user', required: true
      error 204, "Removed project successfully"
      error 404, "Project UUID couldn't be found"
      error 422, "Couldn't delete user. Details of failure returned in body."
      example <<-EOS
#{curl_method('users/4fd35cf93ff94a76ab206b11ae3d21e0', '1', {'X': 'DELETE', 'I': nil})}
# =>
HTTP/1.1 204 No Content
      EOS
      def destroy ; end
    end
  end
end
