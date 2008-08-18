require File.join(File.dirname(__FILE__), *%w[test_helper])

require 'simple_config'

class SimpleConfigFunctionalTest < Test::Unit::TestCase
  
  def test_simple_config_with_top_level_settings
    config = SimpleConfig.for(:my_test) do
      set :var_one, 'foo'
      set :var_two, 'bar'
    end
    
    assert_equal 'foo', config.var_one
    assert_equal 'bar', config.var_two
  end
  
  def test_config_with_groups
    config = SimpleConfig.for(:my_test) do
      group :test_group do
        set :var_one, 'foo'
      end
    end
    
    assert_equal 'foo', config.test_group.var_one
  end
  
  def test_config_with_top_level_settings_and_groups
    config = SimpleConfig.for(:my_test) do
      group :test_group do
        set :var_one, 'foo'
      end
      
      set :var_two, 'bar'
    end
    
    assert_equal 'foo', config.test_group.var_one
    assert_equal 'bar', config.var_two
  end
  
  def test_config_with_nested_groups
    config = SimpleConfig.for(:my_test) do
      group :test_group do
        group :inner_group do
          set :var_one, 'foo'
        end
      end
    end
    
    assert_equal 'foo', config.test_group.inner_group.var_one
  end
  
  def test_config_with_externally_loaded_ruby_config
    sample_file = File.join(File.dirname(__FILE__), *%w[example.rb])
    File.open(sample_file, "w") do |io|
      io << %(
        set :foo, 'bar'
      )
    end
    
    config = SimpleConfig.for(:my_test) do
      load sample_file
    end
    
    assert_equal 'bar', config.foo
    
    FileUtils.rm_f(sample_file)
  end
  
  def test_config_with_externally_loaded_yaml_config
    sample_file = File.join(File.dirname(__FILE__), *%w[example.yml])
    File.open(sample_file, "w") do |io|
      io << %(
      example:
        foo: bar
        baz: qux
      
      test: foo
      )
    end
    
    config = SimpleConfig.for(:my_test) do
      load sample_file
    end
    
    assert_equal 'foo', config.test
    assert_equal 'bar', config.example.foo
    assert_equal 'qux', config.example.baz
    
    FileUtils.rm_f(sample_file)
  end
  
  def test_config_with_optional_external_config
    assert_nothing_raised do
      SimpleConfig.for(:my_test) do
        load "non_existent_file", :if_exists? => true
      end
    end
  end
  
end