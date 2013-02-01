require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'yaml'

describe UserAgentParser::Parser do

  PARSER = UserAgentParser::Parser.new

  # Some Ruby versions (JRuby) need sanitised test names, as some chars screw
  # up the test method definitions
  def self.test_case_to_test_name(test_case)
    name = "#{test_case['user_agent_string']}_#{test_case['family']}"
    name.gsub(/[^a-z0-9_.-]/i, '_').squeeze('_')
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

  def self.device_test_cases
    file_to_test_cases("test_device.yaml")
  end
  
  def custom_patterns_path
    File.join(File.dirname(__FILE__), "custom_regexes.yaml")
  end

  describe "::parse" do
    it "parses a UA" do
      ua = UserAgentParser.parse("Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/418.8 (KHTML, like Gecko) Safari/419.3")
      ua.family.must_equal("Safari")
    end
    it "accepts a custom patterns path" do
      ua = UserAgentParser.parse("Any user agent string", custom_patterns_path)
      ua.family.must_equal("Custom browser")
    end
  end

  describe "#initialize with a custom patterns path" do
    it "uses the custom patterns" do
      parser = UserAgentParser::Parser.new(custom_patterns_path)
      ua = parser.parse("Any user agent string")

      ua.name.must_equal("Custom browser")
      ua.version.major.must_equal("1")
      ua.version.minor.must_equal("2")
      ua.version.patch.must_equal("3")

      ua.os.name.must_equal("Custom OS")
      ua.os.version.major.must_equal("1")
      ua.os.version.minor.must_equal("2")

      ua.device.name.must_equal("Custom device")
    end
  end

  describe "#parse" do
    user_agent_test_cases.each do |test_case|
      it "parses UA for #{test_case_to_test_name(test_case)}" do
        user_agent = PARSER.parse(test_case['user_agent_string'])

        if test_case['family']
          user_agent.name.must_equal_test_case_property(test_case, 'family')
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
        user_agent = PARSER.parse(test_case['user_agent_string'])
        operating_system = user_agent.os

        if test_case['family']
          operating_system.name.must_equal_test_case_property(test_case, 'family')
        end

        if test_case['major']
          operating_system.version.major.must_equal_test_case_property(test_case, 'major')
        end

        if test_case['minor']
          operating_system.version.minor.must_equal_test_case_property(test_case, 'minor')
        end

        if test_case['patch']
          operating_system.version.patch.must_equal_test_case_property(test_case, 'patch')
        end

        if test_case['patch_minor']
          operating_system.version.patch_minor.must_equal_test_case_property(test_case, 'patch_minor')
        end
      end
    end

    device_test_cases.each do |test_case|
      it "parses device for #{test_case_to_test_name(test_case)}" do
        user_agent = PARSER.parse(test_case['user_agent_string'])
        device = user_agent.device

        if test_case['family']
          device.name.must_equal_test_case_property(test_case, 'family')
        end
      end
    end
  end
end
