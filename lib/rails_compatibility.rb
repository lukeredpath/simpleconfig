unless Rails.respond_to?(:env)
  Rails.instance_eval do
    def env
      RAILS_ENV
    end
  end
end
