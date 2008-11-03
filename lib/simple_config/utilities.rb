require 'uri'

module SimpleConfig
  module Utilities
    class NetworkHost
      attr_reader :name, :port

      def initialize(name, port = nil)
        @name, @port = name, port
      end

      def self.from_string(host_string)
        host, port = host_string.split(':')
        new(host, port.to_i)
      end

      def to_uri(uri_options = {})
        options = uri_options.except(:host, :port)
        URI::Generic.build(options.reverse_merge(:host => name, :port => port, :scheme => 'http'))
      end

      def url_for_path(path)
        to_uri(:path => path).to_s
      end

      def to_s
        [name, port].compact.join(':')
      end
    end
  end
end