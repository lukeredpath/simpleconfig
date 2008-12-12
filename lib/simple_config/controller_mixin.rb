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
