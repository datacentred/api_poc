class V1::UsersController < AuthorizedController
  include UsersDoc

  def create
    respond_with({'message': 'created'})
  end

  def index
    respond_with([{'foo': 'bar'}])
  end

  def update
    respond_with({'message': 'updated'})
  end

  def show
    respond_with({'foo': 'bar'})
  end

  def destroy
    respond_with({'message': 'destroyed'})
  end
end