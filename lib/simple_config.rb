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
      returning @configs[config_name] ||= Config.new do |config|
        config.configure(&block) if block_given?
      end
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
      returning @groups[name] ||= Config.new do |group|
        group.configure(&block) if block_given?
      end
    end
    
    def set(key, value)
      @settings[key] = value
    end
    
    def get(key)
      @settings[key]
    end
    
    def load(external_config_file, options={})
      options.reverse_merge!(:if_exists? => false)
      
      if options[:if_exists?]
        return unless File.exist?(external_config_file)
      end
      
      instance_eval(File.read(external_config_file))
    end
    
    private
      def method_missing(method_name, *args)
        case true
        when @groups.key?(method_name)
          return @groups[method_name]
        when @settings.key?(method_name)
          return get(method_name)
        else
          super(method_name, *args)
        end
      end
  end
  
end