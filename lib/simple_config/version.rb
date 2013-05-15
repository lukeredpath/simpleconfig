module SimpleConfig

  module Version
    MAJOR = 2
    MINOR = 0
    PATCH = 1
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join(".")
  end

  VERSION = Version::STRING

end
