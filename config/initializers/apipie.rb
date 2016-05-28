Apipie.configure do |config|
  config.app_name                = "ApiPoc"
  config.api_base_url            = ""
  config.doc_base_url            = "/docs"
  config.default_version         = Rails.configuration.latest_api_version.downcase.to_s
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
