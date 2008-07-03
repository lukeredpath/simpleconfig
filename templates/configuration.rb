SimpleConfig.for :application do

  # your app configuration here
  
  load File.join(RAILS_ROOT, 'config', "settings", "#{RAILS_ENV}.rb"), :if_exists? => true
  load File.join(RAILS_ROOT, 'config', "settings", "local.rb"),        :if_exists? => true
  
end
