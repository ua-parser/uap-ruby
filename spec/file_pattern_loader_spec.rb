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
      result.keys.each do |type|
        result[type].each do |pattern|
          pattern['regex'].must_be_instance_of Regexp
        end
      end
    end

    it "memoizes result" do
      loader = described_class.new(UserAgentParser::DefaultPatternPath)
      result = loader.call
      result.equal?(loader.call).must_equal true
    end

    it "allows forcing a fresh" do
      loader = described_class.new(UserAgentParser::DefaultPatternPath)
      result = loader.call
      fresh_result = loader.call(:fresh => true)
      result.equal?(fresh_result).must_equal false
      fresh_result.equal?(loader.call).must_equal true
    end
  end
end
