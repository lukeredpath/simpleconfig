require File.join(File.dirname(__FILE__), *%w[test_helper])

require 'simple_config'

class YAMLParserTest < Test::Unit::TestCase
  include SimpleConfig
  
  def setup
    @config = Config.new
  end
  
  def test_parsing_of_a_single_variable
    parser = YAMLParser.new({'foo' => 'bar'}.to_yaml)
    parser.parse_into(@config)

    assert_equal 'bar', @config.foo
  end
  
  def test_parsing_of_multiple_variables
    parser = YAMLParser.new({'foo' => 'bar', 'baz' => 'qux'}.to_yaml)
    parser.parse_into(@config)

    assert_equal 'bar', @config.foo
    assert_equal 'qux', @config.baz
  end
  
  def test_parsing_of_a_group_with_one_variable
    parser = YAMLParser.new({'group1' => {'foo' => 'bar'}}.to_yaml)
    parser.parse_into(@config)
    
    assert_equal 'bar', @config.group1.foo
  end
  
  def test_parsing_of_a_group_with_two_variables
    parser = YAMLParser.new({'group1' => {'foo' => 'bar', 'baz' => 'qux'}}.to_yaml)
    parser.parse_into(@config)
    
    assert_equal 'bar', @config.group1.foo
    assert_equal 'qux', @config.group1.baz
  end
  
  def test_parsing_of_a_nested_group
    parser = YAMLParser.new({'group1' => {'group2' => {'foo' => 'bar'}}}.to_yaml)
    parser.parse_into(@config)
    
    assert_equal 'bar', @config.group1.group2.foo
  end
end

class YAMLParserFromContentsOfFile < Test::Unit::TestCase
  include SimpleConfig
  
  def test_should_initialize_new_parser_from_contents_of_given_file
    File.stubs(:read).with('config.yml').returns(yaml_data = stub('yaml data'))
    YAMLParser.expects(:new).with(yaml_data).returns(parser = stub('YAMLParser'))
    assert_equal parser, YAMLParser.parse_contents_of_file('config.yml')
  end
end
