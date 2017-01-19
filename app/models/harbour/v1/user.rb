module Harbour
  module V1
    class User < ::Stronghold::User
      def as_json(options={})
        {
          uuid:       self.uuid,
          email:      self.email,
          first_name: self.first_name,
          last_name:  self.last_name,
          projects:   self.projects.map{|project| project.as_json(only: [:uuid, :name]) }
        }
      end
    end
  end
end
