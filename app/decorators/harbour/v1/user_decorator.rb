module Harbour
  module V1
    class UserDecorator < DecoratorBase
      def as_json(options={})
        {
          uuid:       model.uuid,
          email:      model.email,
          first_name: model.first_name,
          last_name:  model.last_name,
          projects:   model.projects.map{|project| project.as_json(only: [:uuid, :name]) }
        }
      end
    end
  end
end
