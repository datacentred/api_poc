module Harbour
  module V1
    class UserDecorator < DecoratorBase
      def as_json(options={})
        {
          uuid:       model.uuid,
          email:      model.email,
          first_name: model.first_name,
          last_name:  model.last_name,
          created_at: model.created_at,
          updated_at: model.updated_at,
          links:      [{"href": "#{Harbour::Engine.config.public_url}/api/users/#{model.uuid}", "rel": "self"}]
        }.merge(
          (!options[:only] || options[:only].include?(:projects)) ? {projects: model.projects.map{|project| Harbour::V1::ProjectDecorator.new(project).as_json(only: [:uuid, :name]) }} : {}
        )
      end
    end
  end
end
