require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::Parser do

  before do
    @parser ||= UserAgentParser::Parser.new
  end

  describe "#parse" do
    ua_parser_test_cases.each do |tc|
      it "should parse #{tc['user_agent_string']}" do
        ua = @parser.parse(tc['user_agent_string'])
        ua.must_satisfy_test_case tc
      end
    end
  end
  
end
