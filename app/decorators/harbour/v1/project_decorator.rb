module Harbour
  module V1
    class ProjectDecorator < ModelBase
      def as_json(options={})
        {
          uuid:  model.uuid,
          name:  model.name,
          users: model.users.map{|user| user.as_json(only: [:uuid, :email])}
        }
      end
    end
  end
end
