class V2::UsersController < ApplicationController

  resource_description do
    formats [:json]
    api_versions 'v2'
  end

  api :POST, '/users', 'Create user'
  description 'Create user with specifed user params'
  param :user, Hash, desc: 'User information' do
    param :full_name, String, desc: 'Full name of the user'
    param :age, Fixnum, desc: 'Age of the user'
    param :job, Fixnum, desc: 'Job of the user'
  end
  def create
    
  end

  def index
    render json: {}
  end
end