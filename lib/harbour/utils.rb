module Harbour
  module Utils

    def self.extended(base)
      @@base = base
    end

    def self.api_version(klass)
      klass.to_s.split("::")[1].downcase.gsub("v","").to_i
    end

    def self.controller_name(klass)
      doc_class = klass.to_s.split("::").last.to_s
      doc_class[0, doc_class.length-3].downcase
    end

    def examples(action, controller=Harbour::Utils.controller_name(@@base), version=Harbour::Utils.api_version(@@base))
      base_file_path = Harbour::Engine.root.join("app/schema/harbour/v#{version}/examples/#{controller}/#{action}/*.json")
      Dir[base_file_path].map do |file|
        curl_method(JSON.parse(File.read(file))).each{|ex| @@base.example ex }
      end
    end

    def json_schema(controller, name)
      version   = Harbour::Utils.api_version(controller.class)
      file_path = Harbour::Engine.root.join("app/schema/harbour/v#{version}/#{name.parameterize}.json")
      return nil unless File.exists? file_path
      JSON.parse File.read(file_path)
    end

    private

    def curl_method(example)
      headers = {'H' => ["Accept: #{Mime::Type.lookup_by_extension(:dc_json)}; version=#{example['api_version']}",
                             "Authorization: Token token=\"$DATACENTRED_ACCESS:$DATACENTRED_SECRET\"",
                             "Content-Type: application/json"
                            ],
                  'X' => example['verb'],
                }
      command  = "# #{example['description']}\ncurl -s '#{Harbour::Engine.config.public_url}#{example['path']}' \\\n#{to_args(headers)}"
      command  = "#{command} \\\n-d '#{JSON.generate(example['request_data'], space: ' ') rescue '{}'}'" if example['request_data']
      response = "# HTTP/1.1 #{example['head']} #{Rack::Utils::HTTP_STATUS_CODES[example['head']]} \n#{JSON.pretty_generate(example['response_data']) rescue 'null'}"
      [command, response]
    end

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
