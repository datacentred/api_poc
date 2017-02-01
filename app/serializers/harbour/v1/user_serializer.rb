module Harbour
  module V1
    class UserSerializer
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def serialize(options={})
        {
          uuid:       user.uuid,
          email:      user.email,
          first_name: user.first_name,
          last_name:  user.last_name,
          created_at: user.created_at,
          updated_at: user.updated_at,
          links:      [{"href": "#{Harbour::Engine.config.public_url}/api/users/#{user.uuid}", "rel": "self"}]
        }.merge(
          (!options[:only] || options[:only].include?(:projects)) ? {projects: user.projects.map{|project| Harbour::V1::ProjectSerializer.new(project).serialize(only: [:uuid, :name]) }} : {}
        )
      end
    end
  end
end
