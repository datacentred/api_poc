Rails.configuration.api_versions.each do |v|
  require_relative "./routes/api_routes/#{v.to_s.downcase}"
end

Harbour::Engine.routes.draw do
  apipie

  root :to => redirect('/api/docs')
  
  Rails.configuration.api_versions.each do |version|
    scope module: version.downcase, constraints: Harbour::ApiVersionConstraint.new(version: version) do
      extend "ApiRoutes::#{version}".constantize
    end
  end
end
