module Harbour
  module CurlHelper
    def curl_method(path, version, params={})
      params.merge!({'H' => ["Accept: #{Mime::Type.lookup_by_extension(:dc_json)}; version=#{version}",
                             "Authorization: Token token=\"ACCESS_KEY:SECRET_KEY\"",
                             "Content-Type: application/json"
                            ]})
      "curl '#{Harbour::Engine.config.public_url}/#{path}' \\\n#{to_args(params)}"
    end

    private

    def to_args(params)
      params.map do |k, v|
        to_arg(k,v)
      end.flatten.join(" \\\n")
    end

    def to_arg(k,v)
      v.is_a?(Array) ? v.map {|e| "-#{k} '#{e}'"} : "-#{k}".concat(v ? " '#{v}'" : '')
    end
  end
end
