module Harbour
  def self.app_info
    <<-EOS
## Welcome to the DataCentred API documentation

This API allows you to automate operations against your DataCentred account
in a similar way to how you would automate operations against your OpenStack
infrastructure.

Operations include:

* Creating and managing users;
* Creating and managing roles for users;
* Managing OpenStack Project creation, quota adjustments, and user assignments;
* Viewing detailed usage/billing information for your account.

If you have any questions or need any help, please [raise a support ticket](https://my.datacentred.io/account/tickets)!

## 🔑 Authentication

The API uses two pieces of information to authenticate access.

* A unique access key specific to your DataCentred account;
* A secret key which is generated once. If you lose this, you will need to generate another.

Your API access key and secret key can be obtained via [my.datacentred.io](https://my.datacentred.io/account)

Use the `Authorization` header to supply your access key and secret key:

<pre class="prettyprint">
curl '#{Harbour::Engine.config.public_url}/users' \\
-H 'Authorization: Token token=<strong>"access_key:secret_key"</strong>'
{"users":[{"uuid":"55a927f50f...}]}</pre>

<div class="bg-info"><strong>💡 Note:</strong> Your token should be your access key and your secret key separated by a colon.</div>

## 📌 API Versioning

Target specific versions and formats by using the `Accept` header:

<pre class="prettyprint">
curl '#{Harbour::Engine.config.public_url}/projects' \\
-H 'Authorization: Token token="access_key:secret_key"' \\
-H 'Accept: application/vnd.datacentred.api+json; <strong>version=1</strong>'
{"projects":[{"uuid":"55a927f50f...}]}</pre>
    EOS
  end

  Apipie.configure do |config|
    config.app_name                = "DataCentred API"
    config.copyright               = "DataCentred Ltd #{Time.now.year}"
    config.api_base_url            = ""
    config.doc_base_url            = "/api/docs"
    config.default_version         = Harbour::Engine.config.latest_api_version.downcase.to_s
    config.api_controllers_matcher = "#{Harbour::Engine.root}/app/controllers/harbour/**/*.rb"
    config.markup                  = Apipie::Markup::Markdown.new
    config.validate                = false
    config.app_info                = Harbour::app_info
  end
end