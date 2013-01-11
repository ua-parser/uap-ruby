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
    # args - The Hash of arguments.
    #        :fresh - The Boolean which determines whether to return the
    #                 memoized result or load the patterns again and
    #                 re-memoize them.
    #
    # Returns Hash of patterns.
    def call(args = {})
      if args.fetch(:fresh, false)
        @call_result = fresh_call
      else
        @call_result ||= fresh_call
      end
    end

    # Private: Loads file, parses contents as YAML and converts patterns to
    # regular expressions each time called.
    #
    # Returns Hash of patterns.
    def fresh_call
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
