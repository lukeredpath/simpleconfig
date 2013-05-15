# Changelog

## 2.0.1

- Fixed invalid class name (GH-20)

## 2.0.0

- Remove deprecated SimpleConfig::Utilities.
- Remove deprecated SimpleConfig::ControllerMixin.
- Remove pre-Rails 3 init.rb file.
- Add Rails 3 support using Railtie.

## 1.2.0

- Updated Rakefile.
- Added support for Bundler.
- Added ability to duplicate a config object using SimpleConfig::Config#dup (GH-14). [Thanks @andriusch]
- Added SimpleConfig::Config#merge and SimpleConfig::Config#merge! (GH-14). [Thanks @andriusch]
- Deprecated SimpleConfig::Utilities.
- Deprecated SimpleConfig::ControllerMixin.

## 1.1.0

- Added #to_hash method (via markschmidt)

## 1.0.2

- Added 'application.rb' to the list of default config files for non-environment specific settings (via weppos)
- SimpleConfig can be loaded using require 'simpleconfig' as well as 'simple_config'
- Adhere to Rails conventions for submodules and directories (via lazyatom)

## 1.0.1

- Removed dependency on ActiveSupport
- Converted from Rails plugin to a gem
