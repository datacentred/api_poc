module Harbour
  module V1
    class UserSerializer
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def serialize(options={})
        {
          id:         user.uuid,
          email:      user.email,
          first_name: user.first_name,
          last_name:  user.last_name,
          created_at: user.created_at.utc.iso8601,
          updated_at: user.updated_at.utc.iso8601,
          links:      [
            {
              "href": "#{Harbour::Engine.config.public_url}/api/users/#{user.uuid}",
              "rel":  "self"
            },
            {
              "href": "#{Harbour::Engine.config.public_url}/api/v1/schemas/user",
              "rel":  "schema"
            }
          ]
        }
      end
    end
  end
end
