$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "haka/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "haka"
  s.version     = Haka::VERSION
  s.authors     = ["Petrus Repo"]
  s.email       = ["petrus.repo@iki.fi"]
  s.homepage    = "https://github.com/pre/hyy-voting-api/"
  s.summary     = "Sign in with CSC Haka SAML2 user accounts."
  s.description = "Allow sign in with user accounts of University of Helsinki."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.0.0"
  s.add_dependency "ruby-saml"

end
