require 'pathname'
require 'user_agent_parser/parser'
require 'user_agent_parser/user_agent'
require 'user_agent_parser/version'
require 'user_agent_parser/operating_system'
require 'user_agent_parser/device'
require 'user_agent_parser/file_pattern_loader'

module UserAgentParser
  # Private: The path to the root of this gem.
  RootPath = Pathname(__FILE__).dirname

  # Private: The path to the vendor directory.
  VendorPath = UserAgentParser::RootPath.join('..', 'vendor').expand_path

  # Private: The path to the default pattern regexes file.
  DefaultPatternPath = VendorPath.join('ua-parser', 'regexes.yaml')

  DefaultPatternLoader = FilePatternLoader.new(DefaultPatternPath)

  # Path to the ua-parser regexes pattern database
  def self.patterns_path
    @patterns_path
  end

  # Sets the path to the ua-parser regexes pattern database
  def self.patterns_path=(path)
    @patterns_path = path
  end

  self.patterns_path = File.join(File.dirname(__FILE__), "../vendor/ua-parser/regexes.yaml")
end
