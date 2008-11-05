require File.join(File.dirname(__FILE__), *%w[test_helper])

require 'simple_config'

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
  
  def test_unset_should_delete_config_values
    @config.set(:foo, 'bar')
    assert_equal('bar', @config.foo)
    @config.unset(:foo)
    assert_raises(NoMethodError) { @config.foo }
  end
  
  def test_unset_should_return_deleted_value
    @config.set(:foo, 'bar')
    assert_equal('bar', @config.unset(:foo))
  end
  
  def test_exists_should_return_whether_variable_isset
    assert(!@config.exists?(:foo))
    @config.set(:foo, 'bar')
    assert(@config.exists?(:foo))
    @config.unset(:foo)
    assert(!@config.exists?(:foo))
  end
  
  def test_exists_should_consider_empty_values_as_set
    [nil, 0, ''].each do |empty_value|
      @config.set(:foo, empty_value)
      assert_equal(empty_value, @config.get(:foo))
      assert(@config.exists?(:foo))
    end
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
  
  def test_should_laod_and_parse_external_config_as_yaml_in_context_of_config_instance
    parser = stub('YAMLParser')
    SimpleConfig::YAMLParser.stubs(:parse_contents_of_file).with('external_config.yml').returns(parser)
    parser.expects(:parse_into).with(@config)
    @config.load('external_config.yml')
  end
  
  def test_should_load_and_parse_external_config_as_yaml_if_config_file_has_full_yaml_extension
    parser = stub('YAMLParser')
    SimpleConfig::YAMLParser.expects(:parse_contents_of_file).with('external_config.yaml').returns(parser)
    parser.stubs(:parse_into)
    @config.load('external_config.yaml')
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
