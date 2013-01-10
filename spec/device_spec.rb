require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::Device do
  describe "#to_s" do
    it "returns a string of just the name" do
      os = UserAgentParser::Device.new("iPod")
      os.to_s.must_equal "iPod"
    end
  end

  describe "#==" do
    it "returns true for same name" do
      device1 = UserAgentParser::Device.new("iPod")
      device2 = UserAgentParser::Device.new("iPod")
      device1.must_equal device2
    end

    it "returns false different name" do
      device1 = UserAgentParser::Device.new("iPod")
      device2 = UserAgentParser::Device.new("iPad")
      device1.wont_equal device2
    end
  end

  describe "#eql?" do
    it "returns true for same name" do
      device1 = UserAgentParser::Device.new("iPod")
      device2 = UserAgentParser::Device.new("iPod")
      assert_equal true, device1.eql?(device2)
    end

    it "returns false different name" do
      device1 = UserAgentParser::Device.new("iPod")
      device2 = UserAgentParser::Device.new("iPad")
      assert_equal false, device1.eql?(device2)
    end
  end

  describe "#inspect" do
    it "returns class name and instance to_s" do
      device = UserAgentParser::Device.new("iPod")
      device.inspect.to_s.must_equal '#<UserAgentParser::Device iPod>'
    end
  end
end
