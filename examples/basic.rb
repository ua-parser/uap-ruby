$:.unshift File.expand_path('../../lib', __FILE__)
require 'user_agent_parser'
require 'pp'

parser = UserAgentParser::Parser.new
agent = parser.parse('Mozilla/5.0 (iPhone; U; fr; CPU iPhone OS 4_2_1 like Mac OS X; fr) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148a Safari/6533.18.5')

pp agent.name
# "Mobile Safari"

pp agent.version
#<UserAgentParser::Version 5.0.2>

pp agent.os
#<UserAgentParser::OperatingSystem iOS 4.2.1>

pp agent.os.name
# "iOS"

pp agent.os.version
#<UserAgentParser::Version 4.2.1>

pp agent.device
#<UserAgentParser::Device iPhone>

pp agent.device.name
# "iPhone"

# Note that version, os, and device return nil if not detected.
