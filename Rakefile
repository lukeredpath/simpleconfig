require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require "rubygems"
require "rubygems/package_task"

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the simpleconfig plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the simpleconfig plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Simpleconfig'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|
  s.name     = "simpleconfig"
  s.version  = "1.1.3"
  s.date     = "2010-09-13"
  s.summary  = "Simple object-oriented application settings for Ruby applications"
  s.email    = "luke@lukeredpath.co.uk"
  s.homepage = "http://github.com/lukeredpath/simpleconfig"
  s.description = "SimpleConfig is a plugin designed to make application-wide configuration settings (e.g. in a Rails app) easy to set and access in an object-oriented fashion."
  s.has_rdoc = false
  s.authors  = ["Luke Redpath"]
  s.files    = [
    "lib/simple_config.rb",
    "lib/simple_config/controller_mixin.rb",
    "lib/simple_config/utilities.rb",
    "lib/tasks/simple_config.rake",
    "init.rb",
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

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
#
# To publish your gem online, install the 'gemcutter' gem; Read more
# about that here: http://gemcutter.org/pages/gem_docs
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

task :package => :gemspec

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end

desc "Release to RubyGems.org"
task :release => :package do
  system("gem push pkg/#{spec.file_name}") &&
  system("git tag -a -m 'Tagged #{spec.version} release' v#{spec.version}") &&
  system("git push --tags")
end
