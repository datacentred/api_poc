Apipie.configure do |config|
  config.app_name                = "DataCentred RESTful API"
  config.copyright               = "DataCentred Ltd #{Time.now.year}"
  config.doc_base_url            = "/docs"
  config.default_version         = Rails.configuration.latest_api_version.downcase.to_s
  config.api_base_url            = ""
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.markup                  = Apipie::Markup::Markdown.new
  config.validate                = false
  config.app_info                = <<-EOS
# Authentication

Use the `Authorization` header to supply your access key and secret key:

<pre class="prettyprint">
curl '#{CurlHelper.api_base_display_url}/status' \\
-H 'Authorization: Token e72b2001dd:ff8293d2aa'</pre>

# Versions & Formats

Target specific versions and formats by using the `Accept` header:

<pre class="prettyprint">
curl '#{CurlHelper.api_base_display_url}/status' \\
-H 'Accept: application/vnd.datacentred.api+json; version=1'</pre>

Supported formats: json, xml, csv
  EOS
end
