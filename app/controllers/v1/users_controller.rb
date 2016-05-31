class V1::UsersController < ApplicationController
  include UsersDoc

  def create
    render json: {'message': 'created'}
  end

  def index
    render json: [{'foo': 'bar'}]
  end

  def update
    render json: {'message': 'updated'}
  end

  def show
    render json: {'foo': 'bar'}
  end

  def destroy
    render json: {'message': 'destroyed'}
  end
end