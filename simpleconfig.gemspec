Gem::Specification.new do |s|
  s.name     = "simpleconfig"
  s.version  = "1.0"
  s.date     = "2008-12-05"
  s.summary  = "Simple object-oriented application settings"
  s.email    = "contact@lukeredpath.co.uk"
  s.homepage = "http://github.com/lukeredpath/simpleconfig"
  s.description = "Simple Config is a plugin designed to make application-wide configuration settings (e.g. in a Rails app) easy to set and access in an object-oriented fashion."
  s.has_rdoc = false
  s.authors  = ["Luke Redpath"]
  s.files    = [
    "lib/simple_config.rb",
    "lib/controller_mixin.rb",
    "lib/simple_config/utilities.rb"
  ]
  s.test_files = [
    "test/controller_mixin_test.rb",
    "test/network_host_test.rb",
    "test/simple_config_functional_test.rb",
    "test/simple_config_test.rb",
    "test/yaml_parser_test.rb"
  ]
end