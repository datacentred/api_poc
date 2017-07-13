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

  s.add_dependency "rails", "5.0.2"

  s.add_dependency "apipie-rails", "~> 0.4"
  s.add_dependency "maruku", "~> 0.3"
  s.add_dependency "responders", "~> 2.2"
  s.add_dependency "json-schema", "~> 2.7"
  s.add_dependency "nokogiri", "~> 1.7.2"
  s.add_development_dependency "bundler-audit", "~> 0.5"
  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "bcrypt", "~> 3.1"
  s.add_development_dependency "simplecov", "~> 0.10"
  s.add_development_dependency "database_cleaner", "~> 1.5"
  s.add_development_dependency "timecop", "~> 0.8"
  s.add_development_dependency  "minitest", "~> 5.10", "!= 5.10.2"
end
