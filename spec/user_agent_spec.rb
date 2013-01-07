require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::UserAgent do
  describe "#to_s" do
    it "returns a string of just the family" do
      UserAgentParser::UserAgent.new("Chrome").to_s.must_equal "Chrome"
    end

    it "returns a string of family and version" do
      version = UserAgentParser::Version.new("1.2.3pre")
      agent = UserAgentParser::UserAgent.new("Chrome", version)
      agent.to_s.must_equal "Chrome 1.2.3pre"
    end
  end

  describe "#==" do
    it "returns true for same agents with no OS" do
      version = UserAgentParser::Version.new("1.0")
      agent1 = UserAgentParser::UserAgent.new("Chrome", version)
      agent2 = UserAgentParser::UserAgent.new("Chrome", version)
      agent1.must_equal agent2
    end

    it "returns true for same agents on same OS" do
      version = UserAgentParser::Version.new("1.0")
      os = UserAgentParser::OperatingSystem.new('Windows')
      agent1 = UserAgentParser::UserAgent.new("Chrome", version, os)
      agent2 = UserAgentParser::UserAgent.new("Chrome", version, os)
      agent1.must_equal agent2
    end

    it "returns false for same agent on different OS" do
      version = UserAgentParser::Version.new("1.0")
      windows = UserAgentParser::OperatingSystem.new('Windows')
      mac = UserAgentParser::OperatingSystem.new('Mac')
      agent1 = UserAgentParser::UserAgent.new("Chrome", version, windows)
      agent2 = UserAgentParser::UserAgent.new("Chrome", version, mac)
      agent1.wont_equal agent2
    end

    it "returns false for same os, but different family version" do
      family_version1 = UserAgentParser::Version.new("1.0")
      family_version2 = UserAgentParser::Version.new("2.0")
      os = UserAgentParser::OperatingSystem.new('Windows')
      agent1 = UserAgentParser::UserAgent.new("Chrome", family_version1, os)
      agent2 = UserAgentParser::UserAgent.new("Chrome", family_version2, os)
      agent1.wont_equal agent2
    end
  end

  describe "#eql?" do
    it "returns true for same agents with no OS" do
      version = UserAgentParser::Version.new("1.0")
      agent1 = UserAgentParser::UserAgent.new("Chrome", version)
      agent2 = UserAgentParser::UserAgent.new("Chrome", version)
      assert_equal true, agent1.eql?(agent2)
    end

    it "returns true for same agents on same OS" do
      version = UserAgentParser::Version.new("1.0")
      os = UserAgentParser::OperatingSystem.new('Windows')
      agent1 = UserAgentParser::UserAgent.new("Chrome", version, os)
      agent2 = UserAgentParser::UserAgent.new("Chrome", version, os)
      assert_equal true, agent1.eql?(agent2)
    end

    it "returns false for same agent on different OS" do
      version = UserAgentParser::Version.new("1.0")
      windows = UserAgentParser::OperatingSystem.new('Windows')
      mac = UserAgentParser::OperatingSystem.new('Mac')
      agent1 = UserAgentParser::UserAgent.new("Chrome", version, windows)
      agent2 = UserAgentParser::UserAgent.new("Chrome", version, mac)
      assert_equal false, agent1.eql?(agent2)
    end

    it "returns false for same os, but different family version" do
      family_version1 = UserAgentParser::Version.new("1.0")
      family_version2 = UserAgentParser::Version.new("2.0")
      os = UserAgentParser::OperatingSystem.new('Windows')
      agent1 = UserAgentParser::UserAgent.new("Chrome", family_version1, os)
      agent2 = UserAgentParser::UserAgent.new("Chrome", family_version2, os)
      assert_equal false, agent1.eql?(agent2)
    end
  end

  describe "#inspect" do
    it "should return the family and version" do
      family_version = UserAgentParser::Version.new("1.0")
      agent = UserAgentParser::UserAgent.new("Chrome", family_version)
      agent.inspect.to_s.must_equal '#<UserAgentParser::UserAgent Chrome 1.0>'
    end

    it "should return the OS if present" do
      family_version = UserAgentParser::Version.new("1.0")
      os_version = UserAgentParser::Version.new("10.7.4")
      os = UserAgentParser::OperatingSystem.new("OS X", os_version)
      agent = UserAgentParser::UserAgent.new("Chrome", family_version, os)
      agent.inspect.must_equal "#<UserAgentParser::UserAgent Chrome 1.0 (OS X 10.7.4)>"
    end
  end
end
