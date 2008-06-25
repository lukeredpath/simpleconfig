module SimpleConfig
  module ControllerMixin
    def self.included(klass)
      klass.send(:helper_method, :config)
    end
    
    def config
      SimpleConfig.for(:application)
    end
  end
end
