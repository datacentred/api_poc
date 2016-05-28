class ApiVersionConstraint
  attr_reader :version

  def initialize(options)
    @version = options.fetch(:version)
  end

  def matches?(request)
    matches_specific_version?(request) ||
    default_version?(request)
  end

  def matches_specific_version?(request)
    request
      .headers
      .fetch(:accept)
      .include?("version=#{version =~ /\d+/}")
  end

  def default_version?(request)
    Rails.configuration.latest_api_version == version
  end
end