Apipie.configure do |config|
  config.app_name                = "DataCentred RESTful API"
  config.doc_base_url            = "/docs"
  config.default_version         = Rails.configuration.latest_api_version.downcase.to_s
  # config.api_base_url            = "https://api.datacentred.io"
  config.api_base_url            = "https://calm-cove-59936.herokuapp.com"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.markup                  = Apipie::Markup::Markdown.new
  config.validate                = false
  config.app_info                = <<-EOS
# Authentication

TBD

# Versions & Formats

Target specific versions and formats by using the `Accept` header:

<pre class="prettyprint">
curl '#{Apipie.api_base_url}/status' \\
-H 'Accept: application/vnd.datacentred.api+json; version=1' \\
-u 'API_KEY:'</pre>

Supported formats: json, xml, csv
  EOS
end
