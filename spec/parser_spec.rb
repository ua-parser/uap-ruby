require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::Parser do

  before do
    @parser ||= UserAgentParser::Parser.new
  end

  describe "#parse" do
    ua_parser_test_cases.each do |tc|
      it "should parse #{tc['user_agent_string'][0..60]}" do
        ua = @parser.parse(tc['user_agent_string'])

        ua.family.must_equal_test_case_property(tc, 'family') if tc['family']

        ua.version.segment_must_equal_test_case_property(0, tc, 'v1') if tc['v1']
        ua.version.segment_must_equal_test_case_property(1, tc, 'v2') if tc['v2']
        ua.version.segment_must_equal_test_case_property(2, tc, 'v3') if tc['v3']
        
        ua.os.name.must_equal_test_case_property(tc, 'os') if tc['os']
        
        ua.os.version.segment_must_equal_test_case_property(0, tc, 'os_v1') if tc['os_v1']
        ua.os.version.segment_must_equal_test_case_property(1, tc, 'os_v2') if tc['os_v2']
        ua.os.version.segment_must_equal_test_case_property(2, tc, 'os_v3') if tc['os_v3']
        ua.os.version.segment_must_equal_test_case_property(3, tc, 'os_v4') if tc['os_v4']
      end
    end
  end
  
end
