module Harbour
  module V1
    class ProjectSerializer
      attr_reader :project

      def initialize(project)
        @project = project
      end

      def serialize(options={})
        {
          id:         project.uuid,
          name:       project.name,
          created_at: project.created_at,
          updated_at: project.updated_at,
          quota_set:  cast_to_integer(project.quota_set),
          links:      [{"href": "#{Harbour::Engine.config.public_url}/api/projects/#{project.uuid}", "rel": "self"}]
        }
      end

      private

      def cast_to_integer(hash)
        hash.inject({}) do |acc, pair|
          acc[pair[0]] ||= {}
          pair[1].each do |attr, val|
            acc[pair[0]][attr] = val.to_i
          end
          acc
        end
      end
    end
  end
end
