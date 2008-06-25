require 'test/unit'
$LOAD_PATH << File.join(File.dirname(__FILE__), *%w[.. lib])

unless defined?(ActiveSupport) # we aren't in a rails environment
  require 'rubygems'
  require 'active_support'
end

require 'mocha'
