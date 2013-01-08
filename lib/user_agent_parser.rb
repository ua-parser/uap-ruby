require 'user_agent_parser/parser'
require 'user_agent_parser/user_agent'
require 'user_agent_parser/version'
require 'user_agent_parser/operating_system'
require 'user_agent_parser/device'

module UserAgentParser
  # Path to the ua-parser regexes pattern database
  def self.patterns_path
    @patterns_path
  end

  # Sets the path to the ua-parser regexes pattern database
  def self.patterns_path=(path)
    @patterns_path = path
  end

  self.patterns_path = File.join(File.dirname(__FILE__), "../vendor/ua-parser/regexes.yaml")

  # Parse the given +user_agent_string+, returning a +UserAgent+
  def self.parse(user_agent_string)
    Parser.new.parse(user_agent_string)
  end
end
