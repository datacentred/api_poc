module Harbour
  module V1
    class UsageSerializer
      include Harbour::Sortable
      include Harbour::Utc

      attr_reader :usage_data

      def initialize(usage_data, year, month)
        @usage_data   = usage_data
        @year         = year
        @month        = month
      end

      def serialize(options={})
        sort_alphabetically(usage_data).merge(
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
