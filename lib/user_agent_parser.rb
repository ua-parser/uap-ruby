require 'user_agent_parser/parser'
require 'user_agent_parser/user_agent'
require 'user_agent_parser/version'
require 'user_agent_parser/operating_system'
require 'user_agent_parser/device'

module UserAgentParser
  DefaultPatternsPath = File.join(File.dirname(__FILE__), "../vendor/uap-core/regexes.yaml")

  # Parse the given +user_agent_string+, returning a +UserAgent+
  def self.parse(user_agent_string, options={})
    Parser.new(options).parse(user_agent_string)
  end
end
