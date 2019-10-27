# frozen_string_literal: true

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
        'brand'             => test_case['brand'],
        'model'             => test_case['model']
      }
    end.reject do |test_case|
      # We don't do the hacky javascript user agent overrides
      test_case.key?('js_ua') ||
        test_case['family'] == 'IE Platform Preview' ||
        test_case['user_agent_string'].include?('chromeframe;')
    end
  end

  def self.file_to_yaml(resource)
    uap_path = File.expand_path('../../vendor/uap-core', __FILE__)
    resource_path = File.join(uap_path, resource)
    YAML.load_file(resource_path)
  end

  def self.user_agent_test_cases
    file_to_test_cases('test_resources/firefox_user_agent_strings.yaml')
    file_to_test_cases('tests/test_ua.yaml')
  end

  def self.operating_system_test_cases
    file_to_test_cases('tests/test_os.yaml') +
      file_to_test_cases('test_resources/additional_os_tests.yaml')
  end

  def self.device_test_cases
    file_to_test_cases('tests/test_device.yaml')
  end

  def custom_patterns_path
    File.join(File.dirname(__FILE__), 'custom_regexes.yaml')
  end

  describe '::parse' do
    it 'parses a UA' do
      ua = UserAgentParser.parse('Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/418.8 (KHTML, like Gecko) Safari/419.3')
      _(ua.family).must_equal('Safari')
    end
    it 'accepts a custom patterns path' do
      ua = UserAgentParser.parse('Any user agent string', patterns_path: custom_patterns_path)
      _(ua.family).must_equal('Custom browser')
    end
  end

  describe '#initialize with a custom patterns path' do
    it 'uses the custom patterns' do
      parser = UserAgentParser::Parser.new(patterns_path: custom_patterns_path)
      ua = parser.parse('Any user agent string')

      _(ua.family).must_equal('Custom browser')
      _(ua.version.major).must_equal('1')
      _(ua.version.minor).must_equal('2')
      _(ua.version.patch).must_equal('3')
      _(ua.version.patch_minor).must_equal('4')

      _(ua.os.family).must_equal('Custom OS')
      _(ua.os.version.major).must_equal('1')
      _(ua.os.version.minor).must_equal('2')

      _(ua.device.family).must_equal('Custom device')
    end
  end

  describe '#parse' do
    user_agent_test_cases.each do |test_case|
      it "parses UA for #{test_case_to_test_name(test_case)}" do
        user_agent = PARSER.parse(test_case['user_agent_string'])

        if test_case['family']
          _(user_agent.family).must_equal_test_case_property(test_case, 'family')
        end

        if test_case['major']
          _(user_agent.version.major).must_equal_test_case_property(test_case, 'major')
        end

        if test_case['minor']
          _(user_agent.version.minor).must_equal_test_case_property(test_case, 'minor')
        end

        if test_case['patch']
          _(user_agent.version.patch).must_equal_test_case_property(test_case, 'patch')
        end
      end
    end

    operating_system_test_cases.each do |test_case|
      it "parses OS for #{test_case_to_test_name(test_case)}" do
        user_agent = PARSER.parse(test_case['user_agent_string'])
        operating_system = user_agent.os

        if test_case['family']
          _(operating_system.family).must_equal_test_case_property(test_case, 'family')
        end

        if test_case['major']
          _(operating_system.version.major).must_equal_test_case_property(test_case, 'major')
        end

        if test_case['minor']
          _(operating_system.version.minor).must_equal_test_case_property(test_case, 'minor')
        end

        if test_case['patch']
          _(operating_system.version.patch).must_equal_test_case_property(test_case, 'patch')
        end

        if test_case['patch_minor']
          _(operating_system.version.patch_minor).must_equal_test_case_property(test_case, 'patch_minor')
        end
      end
    end

    device_test_cases.each do |test_case|
      it "parses device for #{test_case_to_test_name(test_case)}" do
        user_agent = PARSER.parse(test_case['user_agent_string'])
        device = user_agent.device

        if test_case['family']
          _(device.family).must_equal_test_case_property(test_case, 'family')
        end

        if test_case['model']
          _(device.model).must_equal_test_case_property(test_case, 'model')
        end

        if test_case['brand']
          _(device.brand).must_equal_test_case_property(test_case, 'brand')
        end
      end
    end
  end
end
