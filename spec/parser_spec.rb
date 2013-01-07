require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::Parser do
  def self.test_case_test_name(test_case)
    user_agent = test_case['user_agent_string']

    # Some Ruby versions (JRuby) need sanitised test names, as some chars screw
    # up the test method definitions
    user_agent.gsub(/[^a-z0-9_.-]/i, '_').squeeze('_')
  end

  def self.ua_parser_test_cases
    parser_test_cases("test_user_agent_parser") +
    parser_test_cases("firefox_user_agent_strings") +
    parser_test_cases("pgts_browser_list")
  end

  def self.os_parser_test_cases
    parser_test_cases("test_user_agent_parser_os") +
    parser_test_cases("additional_os_tests")
  end

  def self.parser_test_cases(file)
    yaml_test_resource(file)['test_cases'].map do |test_case|
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

  def self.yaml_test_resource(resource)
    test_resource_path = File.expand_path('../../vendor/ua-parser/test_resources', __FILE__)
    resource_path = File.join(test_resource_path, "#{resource}.yaml")
    YAML.load_file(resource_path)
  end

  def parser
    @parser ||= UserAgentParser::Parser.new
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
    ua_parser_test_cases.each do |tc|
      it "parses UA for #{test_case_test_name(tc)}" do
        ua = UserAgentParser::Parser.new.parse(tc['user_agent_string'])

        if tc['family']
          ua.family.must_equal_test_case_property(tc, 'family')
        end

        if tc['major']
          ua.version.major.must_equal_test_case_property(tc, 'major')
        end

        if tc['minor']
          ua.version.minor.must_equal_test_case_property(tc, 'minor')
        end

        if tc['patch']
          ua.version.patch.must_equal_test_case_property(tc, 'patch')
        end
      end
    end

    os_parser_test_cases.each do |tc|
      it "parses OS for #{test_case_test_name(tc)}" do
        ua = parser.parse(tc['user_agent_string'])

        if tc['family']
          ua.os.name.must_equal_test_case_property(tc, 'family')
        end

        if tc['major']
          ua.os.version.major.must_equal_test_case_property(tc, 'major')
        end

        if tc['minor']
          ua.os.version.minor.must_equal_test_case_property(tc, 'minor')
        end

        if tc['patch']
          ua.os.version.patch.must_equal_test_case_property(tc, 'patch')
        end

        if tc['patch_minor']
          ua.os.version.patch_minor.must_equal_test_case_property(tc, 'patch_minor')
        end
      end
    end
  end
end
