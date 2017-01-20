$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "harbour/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "harbour"
  s.version     = Harbour::VERSION
  s.authors     = ["Sean Handley"]
  s.email       = [""]
  s.homepage    = "https://github.com/datacentred/harbour"
  s.summary     = "The DataCentred API tool"

  s.files = Dir["{app,config,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails", "5.0.1"

  s.add_dependency "apipie-rails", "~> 0.3"
  s.add_dependency "maruku", "~> 0.3"
  s.add_development_dependency "bundler-audit", "~> 0.5"
  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "bcrypt", "~> 3.1"
end
