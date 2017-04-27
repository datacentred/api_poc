require_dependency "harbour/application_controller"

module Harbour
  class VersionsController < ApplicationController
    include VersionsDoc

    def index
      respond_with(
        {
          "versions": supported_versions.map do |v|
            {
              "id": v.to_s.gsub("V",""),
              "status": (v == latest_version ? "CURRENT" : "SUPPORTED"),
              "links": [{"href": "#{Harbour::Engine.config.public_url}/api", "rel": "self"}]
            }
          end
        }
      )
    end

    private

    def supported_versions
      Harbour::Engine.config.api_versions.sort.reverse
    end

    def latest_version
      Harbour::Engine.config.latest_api_version
    end
  end
end