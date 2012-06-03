require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::OperatingSystem do
  describe "#to_s" do
    it "returns a string of just the name" do
      UserAgentParser::OperatingSystem.new("Windows").to_s.must_equal "Windows"
    end
    it "returns a string of family and version" do
      v = UserAgentParser::Version.new("7")
      UserAgentParser::OperatingSystem.new("Windows", v).to_s.must_equal "Windows 7"
    end
  end
  describe "#==" do
    it "should return true for same user agents across different O/S's" do
      os1 = UserAgentParser::OperatingSystem.new("Windows", UserAgentParser::Version.new("7"))
      os2 = UserAgentParser::OperatingSystem.new("Windows", UserAgentParser::Version.new("7"))
      os1.must_equal os2
    end
  end
end
