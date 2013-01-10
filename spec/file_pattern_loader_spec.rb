require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::FilePatternLoader do
  def described_class
    UserAgentParser::FilePatternLoader
  end

  describe "#initialize" do
    it "sets path" do
      path = 'some/path/for/regexes.yaml'
      loader = described_class.new(path)
      loader.path.must_equal path
    end
  end

  describe "#call" do
    it "returns hash of patterns" do
      loader = described_class.new(UserAgentParser::DefaultPatternPath)
      result = loader.call
      result.must_be_instance_of Hash
      result.keys.sort.must_equal %w[
        device_parsers
        os_parsers
        user_agent_parsers
      ]
    end
  end
end
