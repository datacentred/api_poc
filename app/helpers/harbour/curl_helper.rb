module Harbour
  module CurlHelper
    def curl_method(path, version, params={})
      params.merge!({'H' => ["Accept: #{Mime::Type.lookup_by_extension(:dc_json)}; version=#{version}", "Authorization: Token ACCESS_KEY:SECRET_KEY"]})
      "curl '#{CurlHelper.api_base_display_url}/#{path}' #{to_args(params)}"
    end

    def self.api_base_display_url
      'https://calm-cove-59936.herokuapp.com'
    end

    private

    def to_args(params)
      params.map do |k, v|
        v.is_a?(Array) ? v.map {|e| "-#{k} '#{e}'"} : "-#{k} '#{v}'"
      end.flatten.join(" \\\n")
    end
  end
end
