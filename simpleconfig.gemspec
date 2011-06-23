# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simpleconfig}
  s.version = "1.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Luke Redpath}]
  s.date = %q{2010-09-13}
  s.description = %q{SimpleConfig is a plugin designed to make application-wide configuration settings (e.g. in a Rails app) easy to set and access in an object-oriented fashion.}
  s.email = %q{luke@lukeredpath.co.uk}
  s.files = [%q{lib/simple_config.rb}, %q{lib/simple_config/controller_mixin.rb}, %q{lib/simple_config/utilities.rb}, %q{lib/tasks/simple_config.rake}, %q{init.rb}, %q{Rakefile}, %q{README.textile}, %q{templates/configuration.rb}, %q{test/controller_mixin_test.rb}, %q{test/network_host_test.rb}, %q{test/simple_config_functional_test.rb}, %q{test/simple_config_test.rb}, %q{test/yaml_parser_test.rb}]
  s.homepage = %q{http://github.com/lukeredpath/simpleconfig}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Simple object-oriented application settings for Ruby applications}
  s.test_files = [%q{test/controller_mixin_test.rb}, %q{test/network_host_test.rb}, %q{test/simple_config_functional_test.rb}, %q{test/simple_config_test.rb}, %q{test/yaml_parser_test.rb}]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
