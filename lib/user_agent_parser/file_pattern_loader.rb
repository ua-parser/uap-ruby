require 'yaml'

module UserAgentParser
  class FilePatternLoader
    # Private: The path to load the yaml regexes from.
    attr_reader :path

    # Public: Returns a new instance of the file pattern loader.
    def initialize(path)
      @path = path
    end

    # Public: Loads the file, parses yaml contents, converts patterns to ruby
    # regular expressions and returns result.
    #
    # Returns Hash of patterns.
    def call
      patterns = YAML.load_file(@path)

      patterns.keys.each do |type|
        patterns[type].each do |pattern|
          pattern['regex'] = Regexp.new(pattern['regex'])
        end
      end

      patterns
    end
  end
end
