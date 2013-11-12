require 'user_agent_parser/parser'
require 'user_agent_parser/user_agent'
require 'user_agent_parser/version'
require 'user_agent_parser/operating_system'
require 'user_agent_parser/device'
require 'user_agent_parser/cache'

module UserAgentParser
  DefaultPatternsPath = File.join(File.dirname(__FILE__), "../vendor/ua-parser/regexes.yaml")
  DefaultCache = Cache.new

  # Parse the given +user_agent_string+, returning a +UserAgent+
  def self.parse(user_agent_string, options={})
    DefaultCache.fetch(options).parse(user_agent_string)
  end
end
