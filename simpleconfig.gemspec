# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "simpleconfig"
  s.version = "2.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luke Redpath", "Simone Carletti"]
  s.date = "2013-05-15"
  s.description = "SimpleConfig is a plugin designed to make application-wide configuration settings (e.g. in a Rails app) easy to set and access in an object-oriented fashion."
  s.email = ["luke@lukeredpath.co.uk", "weppos@weppos.net"]
  s.files = [".gitignore", ".travis.yml", "CHANGELOG.md", "Gemfile", "LICENSE", "README.md", "Rakefile", "lib/simple_config.rb", "lib/simple_config/railtie.rb", "lib/simple_config/version.rb", "lib/simpleconfig.rb", "simpleconfig.gemspec", "templates/configuration.rb", "test/simple_config_functional_test.rb", "test/simple_config_test.rb", "test/test_helper.rb", "test/yaml_parser_test.rb"]
  s.homepage = "http://github.com/lukeredpath/simpleconfig"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Simple object-oriented application settings for Ruby applications"
  s.test_files = ["test/simple_config_functional_test.rb", "test/simple_config_test.rb", "test/test_helper.rb", "test/yaml_parser_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.14"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
