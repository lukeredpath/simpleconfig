# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simpleconfig}
  s.version = "1.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luke Redpath"]
  s.autorequire = %q{simpleconfig}
  s.date = %q{2010-09-13}
  s.description = %q{SimpleConfig is a plugin designed to make application-wide configuration settings (e.g. in a Rails app) easy to set and access in an object-oriented fashion.}
  s.email = %q{luke@lukeredpath.co.uk}
  s.files = ["lib/simple_config.rb", "lib/simple_config/controller_mixin.rb", "lib/simple_config/utilities.rb", "lib/rails_compatibility.rb", "lib/tasks/simple_config.rake", "init.rb", "Rakefile", "README.textile", "templates/configuration.rb", "test/controller_mixin_test.rb", "test/network_host_test.rb", "test/simple_config_functional_test.rb", "test/simple_config_test.rb", "test/yaml_parser_test.rb"]
  s.homepage = %q{http://github.com/lukeredpath/simpleconfig}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Simple object-oriented application settings for Ruby applications}
  s.test_files = ["test/controller_mixin_test.rb", "test/network_host_test.rb", "test/simple_config_functional_test.rb", "test/simple_config_test.rb", "test/yaml_parser_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
