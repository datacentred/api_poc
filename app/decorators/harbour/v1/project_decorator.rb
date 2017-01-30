module Harbour
  module V1
    class ProjectDecorator < DecoratorBase
      def as_json(options={})
        {
          uuid:  model.uuid,
          name:  model.name,
          links: [{"href": "#{Harbour::Engine.config.public_url}/api/projects/#{model.uuid}", "rel": "self"}]
        }.merge(
          (!options[:only] || options[:only].include?(:users)) ? { users: model.users.map{|user| Harbour::V1::UserDecorator.new(user).as_json(only: [:email, :first_name, :last_name])} } : {}
        )
      end
    end
  end
end
