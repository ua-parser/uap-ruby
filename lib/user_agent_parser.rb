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

  # Private: The default pattern loader instance to use for all parsers.
  DefaultPatternLoader = FilePatternLoader.new(DefaultPatternPath)
end
