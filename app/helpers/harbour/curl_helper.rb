module Harbour
  module CurlHelper
    def curl_method(example)
      headers = {'H' => ["Accept: #{Mime::Type.lookup_by_extension(:dc_json)}; version=#{example['api_version']}",
                             "Authorization: Token token=\"ACCESS_KEY:SECRET_KEY\"",
                             "Content-Type: application/json"
                            ],
                  'X' => example['verb'],
                }
      command = "curl -s '#{Harbour::Engine.config.public_url}#{example['path']}' \\\n#{to_args(headers)}"
      command = "#{command} \\\n-d #{JSON.generate(example['request_data']) rescue '{}'}" if example['request_data']
      "#{command}\n# => \nStatus: #{example['head']}\nBody: #{JSON.pretty_generate(example['response_data']) rescue 'null'}"
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
