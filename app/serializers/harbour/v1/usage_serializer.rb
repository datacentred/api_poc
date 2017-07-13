module Harbour
  module V1
    class UsageSerializer

      attr_reader :usage_data

      def initialize(usage_data, year, month)
        @usage_data   = usage_data
        @year         = year
        @month        = month
      end

      def serialize(options={})
        usage_data.merge(
          {
            links: [
              {
                "href": "#{Harbour::Engine.config.public_url}/api/usage/#{@year}/#{@month}",
                "rel": "self"
              }
            ]
          }
        )
      end
    end
  end
end
