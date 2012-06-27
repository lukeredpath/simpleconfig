Simple Config is a plugin designed to make application-wide configuration settings easy to set and access in an
 object-oriented fashion.

Rails already provides a way of configuring the framework on a per-environment basis but other than global variables/constants set in each environment file or environment.rb, there isn't a built-in way of providing application-specific settings.

One simple solution is to simply put all of your app configuration into a YAML file and load this somewhere in your environment, but I wanted something a little bit more flexible that we could use across all of our applications and Simple Config is what we came up with.

SimpleConfig was originally written against Rails 1.x and may still work but as of version 1.1.1 the minimum required Rails version is 2.3.5. You may be able to use it with older versions of Rails but YMMV.

WARNING: SimpleConfig 1.x is not fully compatible with Rails 3. It works, but the rake tasks are not automatically loaded. Please upgrade to SimpleConfig 2.0 if you are using Rails 3.


## Getting started

The plugin comes with a rake task to get you up and running quickly, so start by running that.

  $ rake simple_config:setup

This will create a config/settings folder and a blank settings file for each of the main Rails environments. It will also create a copy of the SimpleConfig initializer  in config/initializers/configuration.rb.

Now, if you open up the configuration.rb initializer, you will see something like this:

```ruby
SimpleConfig.for :application do

  # your app configuration here
  
  load File.join(Rails.root, 'config', "settings", "#{RAILS_ENV}.rb"), :if_exists? => true
  load File.join(Rails.root, 'config', "settings", "local.rb"),        :if_exists? => true
  
end
```

This is where you can set any configuration variables that are required across all Rails environments. The `load` method works just like Ruby's built-in load method, except the contents of the file it loads are evaluated within the context of the `SimpleConfig.for` block. The `:if_exists?` flag, when set to true, means that the file will only be loaded if it exists, otherwise it will simply be ignored.

Variables can be overwritten, and are defined in the order that they are loaded, so you can set up default values in the above file and override them in the environment files.

As well as loading a settings file for your current Rails environment, a file called "local.rb" is loaded which is designed as a place for you to override variables specific to your own development environment -- you can just keep a copy of this locally without having to check it into your version control system[1].

## Variables

### Setting Variables

Setting variables is simple and will be familiar to anybody who has used Capistrano. Whether in your main `SimpleConfig.for` block in configuration.rb, or one of your external settings files, use the `set` method:

```ruby
SimpleConfig.for :application do
  set :my_variable, 'hello world'
end
```

SimpleConfig also supports a form of namespacing that allows you to group logical sets of variables together:

```ruby
SimpleConfig.for :application do
  group :awesome_stuff do
    set :my_variable, 'hello world'
  end
end
```

Both the `set` and `load` methods are available within `group` blocks and files loaded inside groups will be evaluated in the context of that group.

Whilst I'd recommend not nesting your groups more than one-level, there is no limit on how deep they can be nested.

### Unsetting variables

Sometimes you might want to completely delete a variable from the collection. Simply setting its value to nil doesn't work because `nil` might be a valid value.
You can delete a variable using the `unset` method.

```ruby
SimpleConfig.for :application do
  set :my_variable, 'hello world'
  
  ...
  
  unset :my_variable
end
```

For instance, this is useful to remove global settings at environment level instead of overwriting the default value with a nonsense-one.
`unset` returns the value of the variable just in case you need to use it elsewhere.

### Does a specific variable exist?

I don't know but you can check it yourself using `exists?` method.

```ruby
config = SimpleConfig.for :application do
  set :my_variable, 'hello world'
end

# write some nice code 
config.exists? :my_variable     # => true
config.exists? :your_variable   # => false
```

## Accessing your configuration

SimpleConfig allows you set as many separate configurations as you like using the `SimpleConfig.for` method, which takes a symbol representing the configuration name, although most people will just create a single "application" config as above. To access this config from anywhere in your application, you can also use `SimpleConfig.for` method without a block, which always returns the named configuration object.

It is worth pointing out that `SimpleConfig.for` provides an almost singleton-style access to a particular named config. Calling `SimpleConfig.for` with a block a second time for a particular named configuration will simply extend the existing configuration, not overwrite it.

Once you have a reference to your configuration object, you can access variables using method access. Given the above example, `:my_variable` would be accessed in the following way:

```ruby
config = SimpleConfig.for(:application)
config.my_variable # => "hello world"
```

Accessing grouped variables works as you would expect:

```ruby
config = SimpleConfig.for(:application)
config.awesome_stuff.my_variable # => "hello world"
```

## Using your configuration in your Rails app

The plugin provides a convenient mixin for your `ApplicationController` to make configuration access as simple as possible. Assuming a configuration called "application" (as in the above examples), it defines a `config` method which can be used in any of your controllers. It also defines this as a method as a view helper using the Rails `helper_method` macro so you can access configuration data in your views. 

Note - there is no direct way of accessing your configuration variables in your models other than making a direct call to `SimpleConfig.for`. I'd recommend designing your models in such a way that configuration data can be passed into them at runtime as method arguments by your controller to avoid coupling your model to SimpleConfig.

To use the mixin, simply include it in your `ApplicationController`:

```ruby
class ApplicationController < ActionController::Base
  include SimpleConfig::ControllerMixin
end
```

Then in your controllers:

```ruby
class MyController < ApplicationController
  def index
    render :text => config.my_config_variable
  end
end
```

The mixin provides also a class-level `config` method to access the configuration when you don't have a controller instance available.

```ruby
class MyController < ApplicationController
  protect_from_forgery :secret => config.secret_token

  def index
    render :text => config.my_config_variable
  end
end
```

fn1(footnote). In fact, I recommend you make sure your version control system ignores this file otherwise you risk checking in a file that will override values in production! If you are using Subversion, simply add local.rb to the svn:ignore property for the config/settings folder.
