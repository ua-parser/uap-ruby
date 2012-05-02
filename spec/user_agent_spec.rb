require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::UserAgent do
  describe "#to_s" do
    it "returns a string of just the family" do
      UserAgentParser::UserAgent.new("Chrome").to_s.must_equal "Chrome"
    end
    it "returns a string of family and version" do
      v = UserAgentParser::Version.new("1.2")
      UserAgentParser::UserAgent.new("Chrome", v).to_s.must_equal "Chrome 1.2"
    end
    it "returns a string of family, version and os" do
      v = UserAgentParser::Version.new("1.2.3pre")
      os = UserAgentParser::OperatingSystem.new("Windows", UserAgentParser::Version.new("2.3.4b6"))
      UserAgentParser::UserAgent.new("Chrome", v, os).to_s.must_equal "Chrome 1.2.3pre (Windows 2.3.4b6)"
    end
  end
  describe "#==" do
    it "should return true for same user agents across different O/S's" do
      ua1 = UserAgentParser::UserAgent.new("Chrome", UserAgentParser::Version.new("1.0"))
      ua2 = UserAgentParser::UserAgent.new("Chrome", UserAgentParser::Version.new("1.0"))
      ua1.must_equal ua2
    end
  end
end
