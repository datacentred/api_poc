module Harbour
  module VersionsDoc
    extend CurlHelper

    def self.superclass
      VersionsController
    end
    extend Apipie::DSL::Concern

    resource_description do
      resource_id 'Versions'
    end

    api :GET, '', 'List all available API versions'
    description <<-EOS
      This endpoint shows all currently supported API versions, including information on their status. An API version may be:

      * `CURRENT`
        * The latest supported version.
      * `SUPPORTED`
        *  A supported older version.
      * `DEPRECATED`
        * Currently supported but soon to be retired.

      ## Note
      This resource does not require authentication.
    EOS
    example <<-EOS
curl '#{Harbour::Engine.config.public_url}'
{
  "versions": [
    {
      "id": "1",
      "status": "CURRENT",
      "links": [
        {
          "href": "http://localhost:3000/api",
          "rel":"self"
        }
      ]
    }
  ]
}
    EOS
    def index ; end
  end
end
