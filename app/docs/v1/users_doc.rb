module V1::UsersDoc
  extend CurlHelper

  def self.superclass
    V1::UsersController
  end
  extend Apipie::DSL::Concern

  resource_description do
    resource_id 'Users'
    api_versions 'v1'
  end

  def_param_group :user do
    param :user, Hash, desc: 'User information', required: true do
      param :full_name, String, desc: 'Full name of the user', required: true
      param :age, Fixnum, desc: 'Age of the user', required: true
    end
  end

  api :POST, '/users', 'Create user'
  description 'Create user with specifed user params'
  param_group :user
  
  example <<-EOS
#{curl_method('users', '1', {'X': 'POST', 'd': '{"user": {"foo": "bar"}}'})}
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
#{curl_method('users/1', '1', {'X': 'PUT', 'd': '{"user": {"foo": "bar"}}'})}
  EOS
  def update ; end

  api :GET, '/users/:uuid', 'Get user'
  description 'Retrieve specified user information'
  param :uuid, String, required: true
  example <<-EOS
#{curl_method('users/1', '1')}
  EOS
  def show ; end

  api :DELETE, '/users/:uuid', 'Delete user'
  description 'Remove specified user'
  param :uuid, String, required: true
  example <<-EOS
#{curl_method('users/1', '1', {'X': 'DELETE'})}
  EOS
  def destroy ; end
end