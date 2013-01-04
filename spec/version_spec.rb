require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::Version do
  describe "#[]" do
    it "should parse '1'" do
      v = UserAgentParser::Version.new("1")
      v[0].must_equal '1'
    end
    it "should parse '1.2'" do
      v = UserAgentParser::Version.new("1.2")
      v[0].must_equal '1'
      v[1].must_equal '2'
    end
    it "should parse '1.2.3'" do
      v = UserAgentParser::Version.new("1.2.3")
      v[0].must_equal '1'
      v[1].must_equal '2'
      v[2].must_equal '3'
    end
    it "should parse '1.2.3b4'" do
      v = UserAgentParser::Version.new("1.2.3b4")
      v[0].must_equal '1'
      v[1].must_equal '2'
      v[2].must_equal '3'
      v[3].must_equal "b4"
    end
    it "should parse '1.2.3-b4'" do
      v = UserAgentParser::Version.new("1.2.3-b4")
      v[0].must_equal '1'
      v[1].must_equal '2'
      v[2].must_equal '3'
      v[3].must_equal "b4"
    end
    it "should parse '1.2.3pre'" do
      v = UserAgentParser::Version.new("1.2.3pre")
      v[0].must_equal '1'
      v[1].must_equal '2'
      v[2].must_equal "3pre"
    end
    it "should parse '1.2.3-45'" do
      v = UserAgentParser::Version.new("1.2.3-45")
      v[0].must_equal '1'
      v[1].must_equal '2'
      v[2].must_equal "3-45"
    end
  end
  describe "#to_s" do
    it "should return the same string as initialized with" do
      UserAgentParser::Version.new("1.2.3b4").to_s.must_equal "1.2.3b4"
    end
  end
  describe "#==" do
    it "should return true for same versions" do
      UserAgentParser::Version.new("1.2.3").must_equal UserAgentParser::Version.new("1.2.3")
    end
  end
  describe "#inspect" do
    it "should return the class and version" do
      UserAgentParser::Version.new("1.2.3").inspect.must_equal "#<UserAgentParser::Version 1.2.3>"
    end
  end
end
