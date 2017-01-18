module Harbour
  class Engine < ::Rails::Engine
    isolate_namespace Harbour

    config.api_versions = [:V1]
    config.latest_api_version = config.api_versions.sort.last
  end
end
