module SimpleConfig

  module Version
    MAJOR = 2
    MINOR = 0
    PATCH = 0
    BUILD = 'dev'

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join(".")
  end

  VERSION = Version::STRING

end
