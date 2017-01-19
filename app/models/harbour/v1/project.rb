module Harbour
  module V1
    class Project < ::Stronghold::Project
      def as_json(options={})
        {
          uuid:  self.uuid,
          name:  self.name,
          users: self.users.map{|user| user.as_json(only: [:uuid, :email])}
        }
      end
    end
  end
end
