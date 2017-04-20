require 'simple_config/version'
require 'simple_config/railtie' if defined?(Rails)

module SimpleConfig

  class << self
    def for(config_name, &block)
      default_manager.for(config_name, &block)
    end

    def default_manager
      @default_manager ||= Manager.new
    end
  end

  class Manager
    def initialize
      @configs = {}
    end

    def for(config_name, &block)
      config = (@configs[config_name] ||= Config.new)
      config.configure(&block) if block_given?
      config
    end
  end

  class Config

    def initialize
      @groups   = {}
      @settings = {}
    end

    def dup
      self.class.new.tap do |duplicate|
        duplicate.merge!(to_hash)
      end
    end

    def configure(&block)
      instance_eval(&block)
    end

    def group(name, &block)
      group = (@groups[name] ||= Config.new)
      group.configure(&block) if block_given?
      define_accessor(name) { group }
      group
    end

    def set(key, value)
      unset(key) if set?(key)
      define_accessor(key) { value }
      @settings[key] = value
    end

    def get(key)
      @settings[key]
    end

    # Unsets any variable with given +key+
    # and returns variable value if it exists, nil otherwise.
    # Any successive call to exists? :key will return false.
    #
    #   exists? :bar      # => false
    #
    #   set :bar, 'foo'
    #   exists? :bar      # => true
    #
    #   unset :bar        # => 'foo'
    #   exists? :bar      # => false
    #
    # @param  [Symbol] The key to unset.
    # @return The current value for +:key+.
    def unset(key)
      singleton_class.send(:remove_method, key)
      setting = @settings.delete(key)
      # If there was a setting return that, otherwise continue to try and remove a group which may exist
      return setting if setting.nil?
      @groups.delete(key)
    end

    # Returns whether a variable with given +key+ is set.
    #
    # Please note that this method doesn't care about variable value.
    # A nil variable is considered as set.
    #
    #   exists? :bar      # => false
    #
    #   set :bar, 'foo'
    #   exists? :bar      # => true
    #
    #   set :bar, nil
    #   exists? :bar      # => true
    #
    # Use unset to completely remove a variable from the collection.
    #
    #   set :bar, 'foo'
    #   exists? :bar      # => true
    #
    #   unset :bar
    #   exists? :bar      # => false
    #
    # @param  [Symbol] The key to check.
    # @return [Boolean] True if the key is set.
    def exists?(key)
      @settings.key?(key) || @groups.key?(key)
    end

    def set?(key)
      @settings.key?(key)
    end

    def to_hash
      hash = @settings.dup
      @groups.each do |key,group|
        hash[key] = group.to_hash
      end
      hash
    end

    def merge!(hash)
      hash.each do |key, value|
        if value.is_a?(Hash)
          group(key.to_sym).merge!(value)
        else
          set(key.to_sym, value)
        end
      end
      self
    end

    def merge(hash)
      dup.merge!(hash)
    end

    def load(external_config_file, options={})
      options = {:if_exists? => false}.merge(options)

      if options[:if_exists?]
        return unless File.exist?(external_config_file)
      end

      case File.extname(external_config_file)
      when /rb/
        instance_eval(File.read(external_config_file))
      when /yml|yaml/
        YAMLParser.parse_contents_of_file(external_config_file).parse_into(self)
      end
    end

  private

    def define_accessor(name, &block)
      singleton_class.class_eval { define_method(name, &block) } if !respond_to?(name) || exists?(name)
    end

    def singleton_class
      class << self
        self
      end
    end
  end

  class YAMLParser
    def initialize(raw_yaml_data)
      require 'yaml'
      require 'erb'
      @data = YAML.load(ERB.new(raw_yaml_data).result(binding))
    end

    def self.parse_contents_of_file(yaml_file)
      new(File.read(yaml_file))
    end

    def parse_into(config)
      config.merge!(@data)
    end
  end

end
