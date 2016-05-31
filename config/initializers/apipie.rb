Apipie.configure do |config|
  config.app_name                = "DataCentred Dashboard API"
  config.doc_base_url            = "/docs"
  config.default_version         = Rails.configuration.latest_api_version.downcase.to_s
  config.api_base_url            = "https://api.datacentred.io"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.app_info                = "User and Project Management API"
  config.markup                  = Apipie::Markup::Markdown.new
  config.validate                = false
end
