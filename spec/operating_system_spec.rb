# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::OperatingSystem do
  describe "#name" do
    it "returns family" do
      os = UserAgentParser::OperatingSystem.new("Windows")
      os.name.must_equal os.family
    end
  end

  describe "#to_s" do
    it "returns a string of just the family" do
      os = UserAgentParser::OperatingSystem.new("Windows")
      os.to_s.must_equal "Windows"
    end

    it "returns a string of family and version" do
      version = UserAgentParser::Version.new("7")
      os = UserAgentParser::OperatingSystem.new("Windows", version)
      os.to_s.must_equal "Windows 7"
    end
  end

  describe "#==" do
    it "returns true for same user agents across different O/S's" do
      version = UserAgentParser::Version.new("7")
      os1 = UserAgentParser::OperatingSystem.new("Windows", version)
      os2 = UserAgentParser::OperatingSystem.new("Windows", version)
      os1.must_equal os2
    end

    it "returns false for same family, different versions" do
      seven = UserAgentParser::Version.new("7")
      eight = UserAgentParser::Version.new("8")
      os1 = UserAgentParser::OperatingSystem.new("Windows", seven)
      os2 = UserAgentParser::OperatingSystem.new("Windows", eight)
      os1.wont_equal os2
    end

    it "returns false for different family, same version" do
      version = UserAgentParser::Version.new("7")
      os1 = UserAgentParser::OperatingSystem.new("Windows", version)
      os2 = UserAgentParser::OperatingSystem.new("Blah", version)
      os1.wont_equal os2
    end
  end

  describe "#eql?" do
    it "returns true for same user agents across different O/S's" do
      version = UserAgentParser::Version.new("7")
      os1 = UserAgentParser::OperatingSystem.new("Windows", version)
      os2 = UserAgentParser::OperatingSystem.new("Windows", version)
      assert_equal true, os1.eql?(os2)
    end

    it "returns false for same family, different versions" do
      seven = UserAgentParser::Version.new("7")
      eight = UserAgentParser::Version.new("8")
      os1 = UserAgentParser::OperatingSystem.new("Windows", seven)
      os2 = UserAgentParser::OperatingSystem.new("Windows", eight)
      assert_equal false, os1.eql?(os2)
    end

    it "returns false for different family, same version" do
      version = UserAgentParser::Version.new("7")
      os1 = UserAgentParser::OperatingSystem.new("Windows", version)
      os2 = UserAgentParser::OperatingSystem.new("Blah", version)
      assert_equal false, os1.eql?(os2)
    end
  end

  describe "#inspect" do
    it "returns class family and instance to_s" do
      version = UserAgentParser::Version.new("10.7.4")
      os = UserAgentParser::OperatingSystem.new("OS X", version)
      os.inspect.to_s.must_equal '#<UserAgentParser::OperatingSystem OS X 10.7.4>'
    end
  end
end
