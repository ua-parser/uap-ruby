require 'yaml'

module UserAgentParser
  class FilePatternLoader
    # Private: The path to load the yaml regexes from.
    attr_reader :path

    # Public: Returns a new instance of the file pattern loader.
    def initialize(path)
      @path = path
    end

    # Public: Loads the file, parses yaml contents and returns result.
    #
    # Returns Hash of patterns.
    def call
      YAML.load_file(@path)
    end
  end
end
