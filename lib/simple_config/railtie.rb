require 'simple_config'
require 'rails'

module Airbrake
  class Railtie < ::Rails::Railtie

    rake_tasks do
      namespace :simpleconfig do
        desc "Initialize SimpleConfig configurations."
        task :setup do
          abort("Already found config/settings. Have you already run this task?.") if File.exist?("config/settings")

          mkdir("config/settings")
          mkdir("config/initializers") unless File.exist?("config/initializers")

          environments = Dir["config/environments/*.rb"].map { |f| File.basename(f, ".rb") }
          environments << "application"
          environments.each { |env| touch("config/settings/#{env}.rb") }

          cp(
              File.expand_path("../../../templates/configuration.rb", __FILE__), 
              "config/initializers/configuration.rb"
          )
        end
      end
    end

  end
end
