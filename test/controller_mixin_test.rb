require File.join(File.dirname(__FILE__), *%w[test_helper])

require 'simple_config'
require 'controller_mixin'

class RailsController
  class << self
    attr_reader :helper_methods
    def helper_method(name)
      (@helper_methods ||= []) << name
    end
  end
end

class ControllerMixinTest < Test::Unit::TestCase

  def setup
    @app_config = SimpleConfig.for(:application) do
    end
    
    @controller_klass = Class.new(RailsController)
  end
  
  def test_should_define_a_config_class_method_that_returns_the_application_config_when_included
    @controller_klass.send(:include, SimpleConfig::ControllerMixin)
    assert_equal @app_config, @controller_klass.config
  end
  
  def test_should_define_a_config_instance_method_that_returns_the_application_config_when_included
    @controller_klass.send(:include, SimpleConfig::ControllerMixin)
    assert_equal @app_config, @controller_klass.new.config
  end
  
  def test_should_define_the_config_method_as_helper_method_to_make_it_available_to_views_when_included
    @controller_klass.send(:include, SimpleConfig::ControllerMixin)
    assert_equal [:config], @controller_klass.helper_methods
  end
end
