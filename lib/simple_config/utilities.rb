require 'uri'

module SimpleConfig
  module Utilities
    class NetworkHost
      attr_reader :name, :port

      def initialize(name, port = nil, secure = false)
        @name, @port = name, port
        @secure = secure
      end
      
      def secure?
        @secure
      end

      def self.from_string(host_string)
        host, port = host_string.split(':')
        new(host, port.to_i)
      end

      def to_uri(uri_options = {})
        options = uri_options.except(:host, :port)
        URI::Generic.build(options.reverse_merge(:host => name, :port => port, :scheme => default_uri_scheme))
      end

      def url_for_path(path)
        to_uri(:path => path).to_s
      end

      def to_s
        [name, port].compact.join(':')
      end
      
      def default_uri_scheme
        secure? ? 'https' : 'http'
      end
    end
  end
end