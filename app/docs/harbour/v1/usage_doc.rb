module Harbour
  module V1
    module UsageDoc
      def self.superclass
        Harbour::V1::UsageController
      end
      extend Apipie::DSL::Concern
      extend Harbour::Utils

      resource_description do
        resource_id 'Usage'
        api_versions 'v1'
      end

      api :GET, '/usage/:year/:month', 'Get usage data'
      description 'Fetch detailed usage data for a given year and month'
      error 200, "Success"
      error 404, "No usage data found for given year/month pair"
      examples 'show'
      def show ; end
    end
  end
end
