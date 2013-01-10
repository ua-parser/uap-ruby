$:.unshift File.expand_path('../../lib', __FILE__)
require 'user_agent_parser'
require 'pp'

class MemoryPatternLoader
  def initialize
    @patterns = {
      'user_agent_parsers' => [
        {
          'regex' => /.*/,
          'family_replacement' => 'Dummy Family',
        },
      ],

      'os_parsers' => [
        {
          'regex' => /.*/,
          'os_replacement' => 'Dummy OS',
        },
      ],

      'device_parsers' => [
        {
          'regex' => /.*/,
          'device_replacement' => 'Dummy Device',
        },
      ],
    }
  end

  def call
    @patterns
  end
end

parser = UserAgentParser::Parser.new(MemoryPatternLoader.new)
agent = parser.parse('WOHOO!')

pp agent.name         # "Dummy Family"
pp agent.os.name      # "Dummy OS"
pp agent.device.name  # "Dummy Device"
