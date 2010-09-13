Gem::Specification.new do |s|
  s.name     = "simpleconfig"
  s.version  = "1.1.2"
  s.date     = "2010-07-31"
  s.summary  = "Simple object-oriented application settings for Ruby applications"
  s.email    = "luke@lukeredpath.co.uk"
  s.homepage = "http://github.com/lukeredpath/simpleconfig"
  s.description = "SimpleConfig is a plugin designed to make application-wide configuration settings (e.g. in a Rails app) easy to set and access in an object-oriented fashion."
  s.autorequire = "simpleconfig"
  s.has_rdoc = false
  s.authors  = ["Luke Redpath"]
  s.files    = [
    "lib/simple_config.rb",
    "lib/simple_config/controller_mixin.rb",
    "lib/simple_config/utilities.rb",
    "lib/rails_compatibility.rb",
    "lib/tasks/simple_config.rake",
    "rails/init.rb",
    "Rakefile",
    "README.textile",
    "templates/configuration.rb"
  ]
  s.test_files = [
    "test/controller_mixin_test.rb",
    "test/network_host_test.rb",
    "test/simple_config_functional_test.rb",
    "test/simple_config_test.rb",
    "test/yaml_parser_test.rb"
  ]
end
