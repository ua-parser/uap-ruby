# frozen_string_literal: true

require 'yaml'

module UserAgentParser
  class Patterns
    @@default_path = File.join(File.dirname(__FILE__), '../../vendor/uap-core/regexes.yaml')

    def initialize
      @cache = {}
      get() # warm the cache for the default patterns
    end

    def get(path = nil)
      path = @@default_path if path.nil?
      @cache[path] ||= load_and_parse(path)
    end

    private

    def load_and_parse(path)
      yml = YAML.load_file(path)

      # Parse all the regexs
      yml.each_pair do |_type, patterns|
        patterns.each do |pattern|
          pattern[:regex] = Regexp.new(pattern['regex'], pattern['regex_flag'] == 'i')
        end
      end

      [yml['user_agent_parsers'], yml['os_parsers'], yml['device_parsers']]
    end
  end
end
