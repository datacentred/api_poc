module V1::UsersDoc

  def self.superclass
    V1::UsersController
  end
  extend Apipie::DSL::Concern

  resource_description do
    resource_id 'Users'
    api_versions 'v1'
  end

  def_param_group :user do
    param :user, Hash, desc: 'User information' do
      param :full_name, String, desc: 'Full name of the user'
      param :age, Fixnum, desc: 'Age of the user'
    end
  end

  api :POST, '/users', 'Create user'
  description 'Create user with specifed user params'
  param_group :user
  def create ; end

  api :GET, '/users', 'List users'
  description <<-EOS
    
  EOS
  example <<-EOS
    $ curl #{Apipie.api_base_url}/users -u API_KEY:
    =>
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
  param :uuid, String
  param_group :user
  def update ; end

  api :GET, '/users/:uuid', 'Get user'
  description 'Retrieve specified user information'
  param :uuid, String
  def show ; end

  api :DELETE, '/users/:uuid', 'Delete user'
  description 'Remove specified user'
  param :uuid, String
  def destroy ; end
end