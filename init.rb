$LOAD_PATH << File.join(File.dirname(__FILE__), *%w[lib])

require 'rails_compatibility' 
require 'simple_config'

ApplicationController.send(:include, SimpleConfig::ControllerMixin)
