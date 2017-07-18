# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::Device do
  describe "#name" do
    it "returns family" do
      os = UserAgentParser::Device.new("iPod")
      os.name.must_equal os.family
    end
  end

  describe "#to_s" do
    it "returns a string of just the family" do
      os = UserAgentParser::Device.new("iPod")
      os.to_s.must_equal "iPod"
    end
  end

  describe "#==" do
    it "returns true for same family" do
      device1 = UserAgentParser::Device.new("iPod")
      device2 = UserAgentParser::Device.new("iPod")
      device1.must_equal device2
    end

    it "returns false different family" do
      device1 = UserAgentParser::Device.new("iPod")
      device2 = UserAgentParser::Device.new("iPad")
      device1.wont_equal device2
    end
  end

  describe "#eql?" do
    it "returns true for same family" do
      device1 = UserAgentParser::Device.new("iPod")
      device2 = UserAgentParser::Device.new("iPod")
      assert_equal true, device1.eql?(device2)
    end

    it "returns false different family" do
      device1 = UserAgentParser::Device.new("iPod")
      device2 = UserAgentParser::Device.new("iPad")
      assert_equal false, device1.eql?(device2)
    end
  end

  describe "#inspect" do
    it "returns class family and instance to_s" do
      device = UserAgentParser::Device.new("iPod")
      device.inspect.to_s.must_equal '#<UserAgentParser::Device iPod>'
    end
  end
end
