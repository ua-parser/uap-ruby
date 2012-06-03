require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::Parser do

  before do
    @parser ||= UserAgentParser::Parser.new
  end
  
  def self.ua_string_to_test_name(ua)
    # Some Ruby versions (JRuby) need sanitised test names, as some chars screw 
    # up the test method definitions
    ua.gsub(/[^a-z0-9_.-]/i,'_')
  end
  def self.test_case_test_name(tc)
    ua_string_to_test_name(tc['user_agent_string'])
  end

  describe "#parse" do
    
    ua_parser_test_cases.each do |tc|
      it "should parse UA for #{test_case_test_name(tc)}" do
        ua = @parser.parse(tc['user_agent_string'])
        ua.family.must_equal_test_case_property(tc, 'family') if tc['family']
        ua.version.major.must_equal_test_case_property(tc, 'major') if tc['major']
        ua.version.minor.must_equal_test_case_property(tc, 'minor') if tc['minor']
        ua.version.patch.must_equal_test_case_property(tc, 'patch') if tc['patch']
      end
    end
    
    os_parser_test_cases.each do |tc|
      it "should parse OS for #{test_case_test_name(tc)}" do
        ua = @parser.parse(tc['user_agent_string'])
        ua.os.name.must_equal_test_case_property(tc, 'family') if tc['family']
        ua.os.version.major.must_equal_test_case_property(tc, 'major') if tc['major']
        ua.os.version.minor.must_equal_test_case_property(tc, 'minor') if tc['minor']
        ua.os.version.patch.must_equal_test_case_property(tc, 'patch') if tc['patch']
        ua.os.version.patch_minor.must_equal_test_case_property(tc, 'patch_minor') if tc['patch_minor']
      end
    end
    
  end
  
end
