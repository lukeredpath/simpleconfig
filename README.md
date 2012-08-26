Simple Config is a plugin designed to make application-wide configuration settings easy to set and access in an
 object-oriented fashion.

This library was originally designed to be a Rails plugin, but it's now a standard Ruby library with no dependency on Rails. You can use it in any Ruby application or project.


## Rails Configuration vs SimpleConfig

Rails already provides a way of configuring the framework on a per-environment or application basis, but the more the application becomes complex, the more the feature shows its limit.

One common solution is to put your app configuration into YAML files and load them somewhere in your environment, but when you have many developers and dynamic configurations this is not always the best choice.

Compared to the default Rails configuration system, SimpleConfig provides the following additional features:

- Ability to define per developer settings using the `local.rb` file
- Ability to nest configurations in groups
- Ability to clone configs
- Ability to load unlimited configuration scripts


## Getting started

The plugin comes with a rake task to get you up and running quickly, so start by running that.

  $ rake simpleconfig:setup

This will create a `config/settings` folder and a blank settings file for each of the main Rails environments. It will also create a copy of the SimpleConfig initializer in `config/initializers/configuration.rb`.

Now, if you open up the `configuration.rb` initializer, you will see something like this:

```ruby
SimpleConfig.for :application do

  # your app configuration here
  
  load File.join(Rails.root, "config", "settings", "application.rb"),   :if_exists? => true
  load File.join(Rails.root, "config", "settings", "#{RAILS_ENV}.rb"),  :if_exists? => true
  load File.join(Rails.root, "config", "settings", "local.rb"),         :if_exists? => true
  
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
config = SimpleConfig.for(:application) do
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

When the application is initalized, by default the configurations are stored in the `:application` stack. You can access them anywhere using

```ruby
SimpleConfig.for(:application)
```

It's a common habit to define a `config` method in your Rails application or Rails libraries to have quick access to the configuration object. You can also use a mixin.

```ruby
module Configurable
  def config
    SimpleConfig.for(:application)
  end
end

class ApplicationController < ActionController::Base
  extend  Configurable
  include Configurable

  def do_something
    # here you can use config
    if config.my_variable 
      render :foo
    end
      render :bar
    else
  end

end
```

An other very common pattern is to assing your configuration object to a constant so that it becomes globally available in your Rails project.

```ruby
# config/initializers/configuration.rb
# after the initialization block
CONFIG = SimpleConfig.for :app
```

Then anywhere in your app

```ruby
def do_something
  if CONFIG.my_variable 
    render :foo
  end
    render :bar
  else
end
```


fn1(footnote). In fact, I recommend you make sure your version control system ignores this file otherwise you risk checking in a file that will override values in production!
