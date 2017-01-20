module Harbour
  module CurlHelper
    def curl_method(path, version, params={})
      params.merge!({'H' => ["Accept: #{Mime::Type.lookup_by_extension(:dc_json)}; version=#{version}", "Authorization: Token ACCESS_KEY:SECRET_KEY"]})
      "curl '#{Harbour::Engine.config.public_url}/#{path}' #{to_args(params)}"
    end

    private

    def to_args(params)
      params.map do |k, v|
        v.is_a?(Array) ? v.map {|e| "-#{k} '#{e}'"} : "-#{k} '#{v}'"
      end.flatten.join(" \\\n")
    end
  end
end
