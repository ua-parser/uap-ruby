require 'minitest/autorun'
require 'yaml'
require 'json'

$:.unshift File.join(File.dirname(__FILE__), "../lib")
require 'user_agent_parser'

def ua_parser_test_cases
  parser_test_cases("test_user_agent_parser") +
  parser_test_cases("firefox_user_agent_strings") +
  parser_test_cases("pgts_browser_list")
end

def os_parser_test_cases
  parser_test_cases("test_user_agent_parser_os") +
  parser_test_cases("additional_os_tests")
end

def parser_test_cases(file)
  yaml_test_resource(file)['test_cases'].map do |tc|
    {
      'user_agent_string' => tc['user_agent_string'],
      'family'      => tc['family'],
      'major'       => tc['major'],
      'minor'       => tc['minor'],
      'patch'       => tc['patch'],
      'patch_minor' => tc['patch_minor'],
    }
  end.reject do |tc|
    # We don't do the hacky javascript user agent overrides
    tc['js_ua']
  end.reject do |tc|
    # For the above reason, we don't detect the IE Platform Preview cases
    tc['family'] == 'IE Platform Preview'
  end.reject do |tc|
    # Same goes for the older chromeframe UA's (the ones without versions)
    tc['user_agent_string'].include?('chromeframe;')
  end
end

def yaml_test_resource(resource)
  YAML.load_file test_resource_path(resource + ".yaml")
end

def test_resource_path resource
  File.join File.dirname(__FILE__), "../vendor/ua-parser/test_resources", resource
end

module MiniTest
  module Assertions
    # Asserts the test case property is equal to the expected value. On failure
    # the message includes the property and user_agent_string from the test
    # case for easier debugging
    def assert_test_case_property_equal test_case, actual, test_case_property
      assert_equal test_case[test_case_property],
                   actual,
                   "#{test_case_property} failed for user agent: #{test_case['user_agent_string']}"
    end
    # Asserts that the version is not nil and that it's segment matches the
    # value of the given test case property
    def assert_version_segment_equal_test_case_property segment, version, test_case, test_case_property
      refute_nil version, "#{test_case_property} failed for user agent: #{test_case['user_agent_string']}"
      assert_test_case_property_equal test_case, version[segment], test_case_property
    end
    Object.infect_an_assertion :assert_test_case_property_equal, :must_equal_test_case_property
    Object.infect_an_assertion :assert_version_segment_equal_test_case_property, :segment_must_equal_test_case_property
  end

end
