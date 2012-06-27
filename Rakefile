require 'rubygems'
require 'rubygems/package_task'
require 'bundler'

$:.unshift(File.dirname(__FILE__) + "/lib")
require 'simple_config/version'


# Run test by default.
task :default => :test


# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|
  s.name     = "simpleconfig"
  s.version  = SimpleConfig::VERSION
  s.summary  = "Simple object-oriented application settings for Ruby applications"
  s.description = "SimpleConfig is a plugin designed to make application-wide configuration settings (e.g. in a Rails app) easy to set and access in an object-oriented fashion."

  s.authors  = ["Luke Redpath", "Simone Carletti"]
  s.email    = ["luke@lukeredpath.co.uk", "weppos@weppos.net"]
  s.homepage = "http://github.com/lukeredpath/simpleconfig"

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths     = %w( lib )

  s.add_development_dependency("rake")
  s.add_development_dependency("yard")
  s.add_development_dependency("mocha")
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

desc "Remove any temporary products, including gemspec"
task :clean => [:clobber] do
  rm "#{spec.name}.gemspec" if File.file?("#{spec.name}.gemspec")
end

desc "Remove any generated file"
task :clobber => [:clobber_package]

desc "Package the library and generates the gemspec"
task :package => [:gemspec]

desc "Release to RubyGems.org"
task :release => :package do
  system("gem push pkg/#{spec.file_name}") &&
  system("git tag -a -m 'Tagged #{spec.version} release' v#{spec.version}") &&
  system("git push --tags")
end


require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = !!ENV["VERBOSE"]
  t.warning = !!ENV["WARNING"]
end


require 'yard/rake/yardoc_task'

YARD::Rake::YardocTask.new(:yardoc) do |y|
  y.options = ["--output-dir", "yardoc"]
end

namespace :yardoc do
  task :clobber do
    rm_r "yardoc" rescue nil
  end
end

task :clobber => "yardoc:clobber"


desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r simple_config.rb"
end
