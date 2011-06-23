require 'yaml'

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
      @groups = {}
      @settings = {}
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
      define_accessor(key) { value }
      @settings[key] = value
    end

    def get(key)
      @settings[key]
    end

    #
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
    def unset(key)
      singleton_class.send(:remove_method, key)
      @settings.delete(key)
    end

    #
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
    def exists?(key)
      @settings.key?(key)
    end

    def to_hash
      hash = @settings.dup
      @groups.each do |key,group|
        hash[key] = group.to_hash
      end
      hash
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
        singleton_class.class_eval { define_method(name, &block) } unless respond_to?(name)
      end

      def singleton_class
        class << self
          self
        end
      end
  end

  class YAMLParser
    def initialize(raw_yaml_data)
      @data = YAML.load(raw_yaml_data)
    end

    def self.parse_contents_of_file(yaml_file)
      new(File.read(yaml_file))
    end

    def parse_into(config)
      @data.each do |key, value|
        parse(key, value, config)
      end
    end

    private
      def parse(key, value, config)
        if value.is_a?(Hash)
          group = config.group(key.to_sym)
          value.each { |key, value| parse(key, value, group) }
        else
          config.set(key.to_sym, value)
        end
      end
  end

end
