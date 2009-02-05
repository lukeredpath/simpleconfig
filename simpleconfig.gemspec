Gem::Specification.new do |s|
  s.name     = "simpleconfig"
  s.version  = "1.0.2"
  s.date     = "2009-02-05"
  s.summary  = "Simple object-oriented application settings"
  s.email    = "luke@lukeredpath.co.uk"
  s.homepage = "http://github.com/lukeredpath/simpleconfig"
  s.description = "Simple Config is a plugin designed to make application-wide configuration settings (e.g. in a Rails app) easy to set and access in an object-oriented fashion."
  s.autorequire = "simple_config"
  s.has_rdoc = false
  s.authors  = ["Luke Redpath"]
  s.files    = [
    "lib/simple_config.rb",
    "lib/simple_config/controller_mixin.rb",
    "lib/simple_config/utilities.rb",
    "lib/rails_compatibility.rb",
    "rails/init.rb",
    "Rakefile",
    "README.textile",
    "tasks/simple_config.rake",
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