require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::Cache do
  def custom_patterns_path
    File.join(File.dirname(__FILE__), "custom_regexes.yaml")
  end

  it 'stores and returns the parser based on options' do
    cache = UserAgentParser::Cache.new
    cached_path = cache.fetch(:patterns_path => UserAgentParser::DefaultPatternsPath).patterns_path
    cached_path.must_equal UserAgentParser::DefaultPatternsPath
  end

  it 'defaults to the default parser' do
    cache = UserAgentParser::Cache.new
    cached_path = cache.fetch(:patterns_path => custom_patterns_path).patterns_path
    cached_path.must_equal custom_patterns_path
  end
end