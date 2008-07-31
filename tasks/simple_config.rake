require 'fileutils'

namespace :simple_config do
  include FileUtils
  
  task :setup do
    raise "This task should be run from within a Rails application." unless File.exist?('config')
    raise "Already found config/settings. Have you already run this task?." if File.exist?('config/settings')
    
    mkdir('config/settings')
    mkdir("config/initializers") unless File.exist?("config/initializers")
    
    Dir["config/environments/*.rb"].each do |f|
      env = File.basename(f, ".rb")
      touch("config/settings/#{env}.rb")
    end
    
    cp(File.join(File.dirname(__FILE__), *%w[.. templates configuration.rb]), 
        "config/initializers/configuration.rb")
  end  
  
end