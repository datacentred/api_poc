module Harbour
  class Engine < ::Rails::Engine
    isolate_namespace Harbour

    require 'responders'

    def public_url
      case Rails.env
      when 'development'
        "http://localhost:3000"
      when 'staging'
        "https://staging-my.datacentred.io"
      else
        "https://my.datacentred.io"
      end
    end

    config.generators do |g|
      g.scaffold_controller :responders_controller
    end

    config.api_versions = [:V1, :V2]
    config.latest_api_version = config.api_versions.sort.last
    config.public_url = public_url
  end
end
