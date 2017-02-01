module Harbour
  module V1
    class ProjectSerializer
      attr_reader :project

      def initialize(project)
        @project = project
      end

      def serialize(options={})
        {
          uuid:  project.uuid,
          name:  project.name,
          created_at: project.created_at,
          updated_at: project.updated_at,
          links: [{"href": "#{Harbour::Engine.config.public_url}/api/projects/#{project.uuid}", "rel": "self"}]
        }.merge(
          (!options[:only] || options[:only].include?(:users)) ? { users: project.users.map{|user| Harbour::V1::UserSerializer.new(user).serialize(only: [:email, :first_name, :last_name])} } : {}
        )
      end
    end
  end
end
