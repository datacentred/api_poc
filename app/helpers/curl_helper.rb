module CurlHelper
  def curl_method(path, version, params={})
    params.merge!({'u' => 'API_KEY:', 'H' => ["Accept: application/datacentred.api+json; version=#{version}"]})
    "curl '#{Apipie.api_base_url}/#{path}' #{to_args(params)}"
  end

  private

  def to_args(params)
    params.map do |k, v|
      v.is_a?(Array) ? v.map {|e| "-#{k} '#{e}'"} : "-#{k} '#{v}'"
    end.flatten.join(' ')
  end
end