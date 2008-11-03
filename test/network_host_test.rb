require File.join(File.dirname(__FILE__), *%w[test_helper])

require 'simple_config/utilities'

class NetworkHostTest < Test::Unit::TestCase
  include SimpleConfig::Utilities
    
  def test_should_default_to_no_port
    host = NetworkHost.new('www.example.com')
    assert_nil host.port
  end
  
  def test_should_build_a_uri_object_with_the_specified_hostname_and_port_and_a_http_scheme
    uri = NetworkHost.new('www.example.com', 9000).to_uri
    assert_instance_of URI::Generic, uri
    assert_equal 'http', uri.scheme
  end
  
  def test_should_build_a_uri_object_with_an_https_scheme_if_secure
    uri = NetworkHost.new('www.example.com', 443, secure = true).to_uri
    assert_equal 'https', uri.scheme
  end
  
  def test_should_return_a_url_for_a_given_path
    host = NetworkHost.new('www.example.com')
    assert_equal 'http://www.example.com/foo/bar', host.url_for_path('/foo/bar')
  end
  
  def test_should_return_a_string_representation
    assert_equal 'www.example.com:9000', NetworkHost.new('www.example.com', 9000).to_s
  end
  
  def test_should_be_constructed_from_a_string_representation
    host = NetworkHost.from_string('www.example.com:9000')
    assert_equal 'www.example.com', host.name
    assert_equal 9000, host.port
  end
end
