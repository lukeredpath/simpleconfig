require File.dirname(__FILE__) + '/../unit_test_helper'

class SimpleConfigConfigTest < Test::Unit::TestCase
  
  def setup
    @config = SimpleConfig::Config.new
  end
  
  def test_should_be_able_to_set_config_values
    @config.set(:var_one, 'hello world')
    assert_equal 'hello world', @config.get(:var_one)
  end
  
  def test_should_be_able_to_access_settings_using_method_access
    @config.set(:foo, 'bar')
    assert_equal 'bar', @config.foo
  end
  
  def test_should_raise_NoMethodError_if_setting_does_not_exist_when_using_method_access
    assert_raises(NoMethodError) { @config.some_non_existent_variable }
  end
  
  def test_should_return_nil_if_setting_does_not_exist_when_using_get
    assert_nil @config.get(:some_non_existent_variable)
  end
  
  def test_should_return_a_new_group_as_a_separate_config
    group = @config.group(:test)
    assert_instance_of(SimpleConfig::Config, group)
    assert_not_equal @config, group
  end
  
  def test_should_return_an_existing_group
    group = @config.group(:test)
    assert_equal group, @config.group(:test)
  end
  
  def test_should_configure_group_with_supplied_block_when_given
    group = @config.group(:test) do
      set :group_var, 'value'
    end
    assert_equal 'value', group.group_var
  end
  
  def test_should_load_and_parse_external_config_as_ruby_in_context_of_config_instance
    File.stubs(:read).with('external_config.rb').returns(ruby_code = stub('ruby'))
    @config.expects(:instance_eval).with(ruby_code)
    @config.load('external_config.rb')
  end
  
  def test_should_load_and_parse_external_config_if_file_exists_when_if_exists_is_true
    File.stubs(:read).with('external_config.rb').returns(ruby_code = stub('ruby'))
    @config.expects(:instance_eval).with(ruby_code)
    File.stubs(:exist?).with('external_config.rb').returns(true)
    @config.load('external_config.rb', :if_exists? => true)
  end
  
  def test_should_not_load_and_parse_external_config_if_file_does_not_exist_when_if_exists_is_true
    @config.expects(:instance_eval).never
    File.stubs(:exist?).with('external_config.rb').returns(false)
    @config.load('external_config.rb', :if_exists? => true)
  end
    
end

class SimpleConfigParserFunctionalTest < Test::Unit::TestCase
  
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
  
  def test_config_with_externally_loaded_config
    sample_file = File.join(File.dirname(__FILE__), *%w[example_rb])
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
  
  def test_config_with_optional_external_config
    assert_nothing_raised do
      SimpleConfig.for(:my_test) do
        load "non_existent_file", :if_exists? => true
      end
    end
  end
  
end