require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'yaml'

describe UserAgentParser::Parser do

  # Some Ruby versions (JRuby) need sanitised test names, as some chars screw
  # up the test method definitions
  def self.test_case_to_test_name(test_case)
    name = "#{test_case['user_agent_string']}_#{test_case['family']}"
    clean_name = name.gsub(/[^a-z0-9_.-]/i, '_').squeeze('_')
  end

  def self.file_to_test_cases(file)
    file_to_yaml(file)['test_cases'].map do |test_case|
      {
        'user_agent_string' => test_case['user_agent_string'],
        'family'            => test_case['family'],
        'major'             => test_case['major'],
        'minor'             => test_case['minor'],
        'patch'             => test_case['patch'],
        'patch_minor'       => test_case['patch_minor'],
      }
    end.reject do |test_case|
      # We don't do the hacky javascript user agent overrides
      test_case.key?('js_ua') ||
        test_case['family'] == 'IE Platform Preview' ||
        test_case['user_agent_string'].include?('chromeframe;')
    end
  end

  def self.file_to_yaml(resource)
    test_resource_path = File.expand_path('../../vendor/ua-parser/test_resources', __FILE__)
    resource_path = File.join(test_resource_path, resource)
    YAML.load_file(resource_path)
  end

  def self.user_agent_test_cases
    file_to_test_cases("test_user_agent_parser.yaml") +
    file_to_test_cases("firefox_user_agent_strings.yaml") +
    file_to_test_cases("pgts_browser_list.yaml")
  end

  def self.operating_system_test_cases
    file_to_test_cases("test_user_agent_parser_os.yaml") +
    file_to_test_cases("additional_os_tests.yaml")
  end

  describe "#initialize" do
    it "defaults patterns path file to global" do
      parser = UserAgentParser::Parser.new
      parser.patterns_path.must_equal(UserAgentParser.patterns_path)
    end

    it "allows overriding the global with a specific file" do
      parser = UserAgentParser::Parser.new('some/path')
      parser.patterns_path.must_equal('some/path')
    end
  end

  describe "#parse" do
    user_agent_test_cases.each do |test_case|
      it "parses UA for #{test_case_to_test_name(test_case)}" do
        user_agent = UserAgentParser::Parser.new.parse(test_case['user_agent_string'])

        if test_case['family']
          user_agent.family.must_equal_test_case_property(test_case, 'family')
        end

        if test_case['major']
          user_agent.version.major.must_equal_test_case_property(test_case, 'major')
        end

        if test_case['minor']
          user_agent.version.minor.must_equal_test_case_property(test_case, 'minor')
        end

        if test_case['patch']
          user_agent.version.patch.must_equal_test_case_property(test_case, 'patch')
        end
      end
    end

    operating_system_test_cases.each do |test_case|
      it "parses OS for #{test_case_to_test_name(test_case)}" do
        user_agent = UserAgentParser::Parser.new.parse(test_case['user_agent_string'])

        if test_case['family']
          user_agent.os.name.must_equal_test_case_property(test_case, 'family')
        end

        if test_case['major']
          user_agent.os.version.major.must_equal_test_case_property(test_case, 'major')
        end

        if test_case['minor']
          user_agent.os.version.minor.must_equal_test_case_property(test_case, 'minor')
        end

        if test_case['patch']
          user_agent.os.version.patch.must_equal_test_case_property(test_case, 'patch')
        end

        if test_case['patch_minor']
          user_agent.os.version.patch_minor.must_equal_test_case_property(test_case, 'patch_minor')
        end
      end
    end
  end
end
