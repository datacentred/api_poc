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
        }
      end
    end
  end
end
