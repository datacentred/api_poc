Rails.application.routes.draw do
  apipie

  root :to => redirect('/docs')
  
  Rails.configuration.api_versions.each do |version|
    scope module: version.downcase, constraints: ApiVersionConstraint.new(version: version) do
      extend "ApiRoutes::#{version}".constantize
    end
  end
end
