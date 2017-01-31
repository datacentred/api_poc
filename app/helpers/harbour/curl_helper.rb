module Harbour
  module CurlHelper
    def curl_method(example)
      headers = {'H' => ["Accept: #{Mime::Type.lookup_by_extension(:dc_json)}; version=#{example['api_version']}",
                             "Authorization: Token token=\"$DATACENTRED_ACCESS:$DATACENTRED_SECRET\"",
                             "Content-Type: application/json"
                            ],
                  'X' => example['verb'],
                }
      command = "# #{example['description']}\ncurl -s '#{Harbour::Engine.config.public_url}#{example['path']}' \\\n#{to_args(headers)}"
      command = "#{command} \\\n-d '#{JSON.generate(example['request_data'], space: ' ') rescue '{}'}'" if example['request_data']
      "#{command}\n\n# HTTP/1.1 #{example['head']} #{Rack::Utils::HTTP_STATUS_CODES[example['head']]} \n#{JSON.pretty_generate(example['response_data']) rescue 'null'}"
    end

    private

    def to_args(params)
      params.map do |k, v|
        to_arg(k,v)
      end.flatten.join(" \\\n")
    end

    def to_arg(k,v)
      v.is_a?(Array) ? v.map {|e| "-#{k} \"#{e}\""} : "-#{k}".concat(v ? " \"#{v}\"" : '')
    end
  end
end
