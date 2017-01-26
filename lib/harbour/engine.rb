module Harbour
  class Engine < ::Rails::Engine
    isolate_namespace Harbour

    require 'responders'

    def public_url
      case Rails.env.development?
      when 'production'
        "https://my.datacentred.io/api"
      when 'staging'
        "https://staging-my.datacentred.io/api"
      else
        "http://localhost:3000/api"
      end
    end

    config.generators do |g|
      g.scaffold_controller :responders_controller
    end

    config.api_versions = [:V1]
    config.latest_api_version = config.api_versions.sort.last
    config.public_url = public_url
  end
end
