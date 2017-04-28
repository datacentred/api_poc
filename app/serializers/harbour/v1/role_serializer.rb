module Harbour
  module V1
    class RoleSerializer
      attr_reader :role

      def initialize(role)
        @role = role
      end

      def serialize(options={})
        {
          id:          role.uuid,
          name:        role.name,
          admin:       role.power_user,
          permissions: role.permissions,
          created_at:  role.created_at,
          updated_at:  role.updated_at,
          links:       [{"href": "#{Harbour::Engine.config.public_url}/api/roles/#{role.uuid}", "rel": "self"}]
        }
      end
    end
  end
end
