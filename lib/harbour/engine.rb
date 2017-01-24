module Harbour
  class Engine < ::Rails::Engine
    isolate_namespace Harbour

    require 'responders'

    config.generators do |g|
      g.scaffold_controller :responders_controller
    end

    config.api_versions = [:V1]
    config.latest_api_version = config.api_versions.sort.last
    config.public_url = Rails.env.development? ? "http://localhost:3000/api" : "https://my.datacentred.io/api"
  end
end
