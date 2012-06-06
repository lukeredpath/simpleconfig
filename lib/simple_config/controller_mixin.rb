warn <<-EOS
DEPRECATION WARNING: SimpleConfig::ControllerMixin is deprecated and will be removed in SimpleConfig 2.0. If you really need this functionality, add the code to your app or consider creating a MicroGem.
See http://jeffkreeftmeijer.com/2011/microgems-five-minute-rubygems/
EOS


module SimpleConfig
  module ControllerMixin
    
    def self.included(base)
      base.extend     ClassMethods
      base.class_eval do
        include       InstanceMethods
        helper_method :config
      end
    end
    
    module ClassMethods
      
      # Returns the application config.
      def config
        SimpleConfig.for(:application)
      end
      
    end
    
    module InstanceMethods
      
      # Instance-level proxy to class-level +config+ method.
      def config
        self.class.config
      end
      
    end
    
  end
end
