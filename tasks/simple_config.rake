require 'fileutils'

namespace :simple_config do
  include FileUtils
  
  task :setup do
    raise "This task should be run from within a Rails application." unless File.exist?('config')
    raise "Already found config/settings. Have you already run this task?." if File.exist?('config/settings')
    
    mkdir('config/settings')
    mkdir("config/initializers") unless File.exist?("config/initializers")
    
    environments =  Dir["config/environments/*.rb"].map { |f| File.basename(f, ".rb") }
    environments << 'application'
    environments.each { |env| touch("config/settings/#{env}.rb") }
    
    cp(File.join(File.dirname(__FILE__), *%w[.. templates configuration.rb]), 
        "config/initializers/configuration.rb")
  end  
  
end