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
* A secret key which is generated once.

To get started:

<ol>
<li>Grab your API access key and secret key via <a href="https://my.datacentred.io/account">my.datacentred.io</a></li>
<li>Export your access key and secret key as environment variables.</li>
<pre class="prettyprint">
export DATACENTRED_ACCESS="my_access"
export DATACENTRED_SECRET="my_secret"
</pre>

<li>Use the <code>Authorization</code> header in your requests to supply your access key and secret key:

<pre class="prettyprint">
curl -s '#{Harbour::Engine.config.public_url}/api/users' \\
-H "Authorization: Token token="$DATACENTRED_ACCESS:$DATACENTRED_SECRET""
</pre></li>
<li>Receive your response
<pre class="prettyprint">
# HTTP/1.1 200 OK
{
  "users": [{...}]
}
</pre>
or
<pre class="prettyprint">
# HTTP/1.1 403 Unauthorized
{
  "errors": [
    {
      "detail": "Token authentication failed. Invalid credentials or API access is not authorized."
    }
  ]
}
</pre>
</li>
</ol>

## 📌 API Versioning

Target specific versions by using the `Accept` header:

<pre class="prettyprint">
curl -I -s '#{Harbour::Engine.config.public_url}/api/projects' \\
-H "Accept: application/vnd.datacentred.api+json; <strong>version=1</strong>" -H "Authorization: Token token="$DATACENTRED_ACCESS:$DATACENTRED_SECRET""
</pre>
<pre class="prettyprint">
# HTTP/1.1 200 OK
# X-API-Version: 1
# X-Request-Id: 5c91637e-a827-41ba-8f6d-416fa4d549d1
# Content-Type: application/vnd.datacentred.api+json; charset=utf-8
</pre>

<div class="bg-info"><strong>💡 Note:</strong> You can discover information about API versions by visiting <a href="/api/docs/v1/versions/index">the versions index</a>.</div>

    EOS
  end

  Apipie.configure do |config|
    config.app_name                = "DataCentred API"
    config.copyright               = "© DataCentred Ltd #{Time.now.year}"
    config.api_base_url            = ""
    config.doc_base_url            = "/api/docs"
    config.default_version         = Harbour::Engine.config.latest_api_version.downcase.to_s
    config.api_controllers_matcher = "#{Harbour::Engine.root}/app/controllers/harbour/**/*.rb"
    config.markup                  = Apipie::Markup::Markdown.new
    config.validate                = false
    config.app_info                = Harbour::app_info
    config.link_extension          = ''
  end
end