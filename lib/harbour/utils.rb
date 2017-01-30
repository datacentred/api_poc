module Harbour
  def self.api_version(klass)
    klass.class.to_s.split("::")[1].downcase.gsub("v","").to_i
  end

  def self.examples(version, controller, action)
    base_file_path = Harbour::Engine.root.join("app/schema/harbour/v#{version}/examples/#{controller}/#{action}/*.json")
    Dir[base_file_path].map do |file|
      JSON.parse(File.read(file))
    end
  end
end